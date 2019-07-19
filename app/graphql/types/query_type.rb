module Types
  class QueryType < Types::BaseObject
    @@sermons_ar_orders = {
      'newest_first' => 'recorded_at DESC',
      'oldest_first' => :recorded_at,
    }

    @@sermons_es_orders = {
      'newest_first' => { recorded_at: :desc },
      'oldest_first' => { recorded_at: :asc },
    }

    class SermonFilter < ::Types::BaseInputObject
      argument :OR, [self], required: false
      argument :identifier, String, required: false
      argument :title, String, required: false
      argument :series_id, ID, required: false
      argument :speaker_id, ID, required: false
    end

    class QueryParsingError < RrpcApi::Error; end

    OrderEnum = GraphQL::EnumType.define do
      name 'SermonOrder'

      value 'newest_first'
      value 'oldest_first'
    end

    add_field GraphQL::Types::Relay::NodeField
    add_field GraphQL::Types::Relay::NodesField

    field :series, SeriesType.connection_type, null: false

    field :sermons, SermonConnectionType, null: false do
      argument :filter, type: SermonFilter, required: false
      argument :search, type: String, required: false
      argument :order, type: OrderEnum, required: false
    end

    field :speakers, SeriesType.connection_type, null: false

    def series
      Series.all
    end

    def sermons(filter: nil, search: nil, order: 'newest_first')
      if search
        if filter
          raise GraphQL::ExecutionError, "Search and filter arguments are mutually exclusive"
        end

        nodes = SermonsIndex.query(query_string: { query: search, default_operator: 'and' })
        nodes = nodes.order(@@sermons_es_orders[order])
        nodes
      else
        scope = apply_filter(Sermon.all, filter) do |scope|
          if filter[:identifier]
            scope = scope.where(identifier: filter[:identifier])
          end

          if filter[:title]
            scope = scope.where(title: filter[:title])
          end

          if filter[:speaker_id]
            type_name, slug = filter[:speaker_id].split('/')
            scope = scope.joins(:speaker).where('speakers.slug = ?', slug)
          end

          if filter[:series_id]
            type_name, slug = filter[:series_id].split('/')
            scope = scope.joins(:series).where('series.slug = ?', slug)
          end

          scope
        end

        scope = scope.order(@@sermons_ar_orders[order])

        scope
      end
    end

    def speakers
      Speaker.all
    end

    def apply_filter(scope, value)
      branches = normalize_filters(scope, value) { |scope| yield(scope) }.reduce { |a, b| a.or(b) }
      scope.merge(branches)
    end

    def normalize_filters(scope, value, branches = [])
      scope = yield(scope)

      branches << scope

      if value['OR'].present?
        value['OR'].reduce(branches) { |s, v| normalize_filters(scope, v, s) }
      end

      branches
    end
  end
end
