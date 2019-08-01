module Types
  class BaseObject < GraphQL::Schema::Object
    implements GraphQL::Types::Relay::Node

    global_id_field :id
  end
end
