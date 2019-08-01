module Types
  class SeriesType < Types::BaseObject
    field :name, String, null: false
    field :speaker, Types::SpeakerType, null: false
    field :sermons_count, Int, null: false

    field :sermons_near_id, [SermonType], null: false do
      argument :id, type: ID, required: true
      argument :order, type: Types::SermonOrder, required: false
      argument :limit, type: Int, required: false
    end

    def speaker
      ::RecordLoader.for(Speaker).load(object.speaker_id)
    end

    def sermons_near_id(id:, order: 'oldest_first', limit: 5)
      _, identifier = id.split('/')
      pivot = Sermon.find_by(identifier: identifier)

      if pivot.nil?
        return []
      end

      index = pivot.series_index
      half = ((limit - 1) / 2).floor
      before = index - 1
      after = object.sermons_count - index
      if before < half
        min_index = 1
        max_index = index + limit - before - 1
      elsif after < half
        min_index = index - limit + after + 1
        max_index = object.sermons_count
      else
        min_index = index - half
        max_index = index + (limit % 2 == 0 ? half + 1 : half)
      end

      Sermon.where(series_id: object.id, series_index: min_index..max_index)
            .order(SermonOrder.order(:ar, order))
            .to_a
    end
  end
end
