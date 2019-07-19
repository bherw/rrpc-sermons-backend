module Types
  class ChewyRelationConnection < GraphQL::Relay::RelationConnection
    # Modified from GraphQL::Relay::RelationConnection
    # limits are always set, and we need to make a different call to get ActiveRecord objects
    # apply first / last limit results
    # @return [Array]
    def paged_nodes
      return @paged_nodes if defined? @paged_nodes

      items = sliced_nodes

      if first
        # MODIFIED
        items = items.limit(first)
      end

      if last
        if relation_limit(items)
          if last <= relation_limit(items)
            offset = (relation_offset(items) || 0) + (relation_limit(items) - last)
            items = items.offset(offset).limit(last)
          end
        else
          slice_count = relation_count(items)
          offset = (relation_offset(items) || 0) + slice_count - [last, slice_count].min
          items = items.offset(offset).limit(last)
        end
      end

      if max_page_size && !first && !last
        # MODIFIED
        items = items.limit(max_page_size)
      end

      # Store this here so we can convert the relation to an Array
      # (this avoids an extra DB call on Sequel)
      @paged_nodes_offset = relation_offset(items)

      # MODIFIED: Chewy::Search::Request.to_a returns Chewy Type objects,
      # but we need the actual objects.
      @paged_nodes = items.objects
    end

    def relation_count(relation)
      relation.count
    end

    def limit_nodes(sliced_nodes, limit)
      sliced_nodes.limit(limit)
    end
  end
end