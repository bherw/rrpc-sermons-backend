class RrpcApiSchema < GraphQL::Schema
  default_max_page_size 100

  mutation(Types::MutationType)
  query(Types::QueryType)

  use GraphQL::Batch

  def self.id_from_object(object, type_definition, query_ctx)
    type_name = object.respond_to?(:graphql_type_name) ? object.graphql_type_name : object.class.table_name
    "#{type_name}/#{object.slug}"
  end

  def self.resolve_type(type, obj, ctx)
    case obj
    when Series
      Types::SeriesType
    when Sermon
      Types::SermonType
    when Speaker
      Types::SpeakerType
    else
      raise "Unexpected object: #{obj}"
    end
  end

  def self.object_from_id(id, query_ctx)
    type_name, slug = id.split('/')

    case type_name
    when 'series'
      Series.find_by(slug: slug)
    when 'sermons'
      Sermon.find_by(identifier: slug)
    when 'speakers'
      Speaker.find_by(slug: slug)
    else
      raise GraphQL::ExecutionError, "Invalid id: #{id}"
    end
  end
end
