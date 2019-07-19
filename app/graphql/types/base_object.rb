module Types
  class BaseObject < GraphQL::Schema::Object
    implements GraphQL::Relay::Node.interface

    global_id_field :id
  end
end
