module Types
  class SermonEdgeType < GraphQL::Types::Relay::BaseEdge
    node_type SermonType
  end

  class SermonConnectionType < GraphQL::Types::Relay::BaseConnection
    edge_type SermonEdgeType

    field :total_count, Integer, null: false
    def total_count
      object.nodes.count
    end
  end
end