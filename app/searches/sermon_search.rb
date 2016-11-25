class SermonSearch
  @@ar_orders = {
    'newest_first' => 'recorded_at DESC',
    'oldest_first' => :recorded_at,
  }

  @@es_orders = {
    'newest_first' => { recorded_at: :desc },
    'oldest_first' => { recorded_at: :asc },
  }

  def initialize(params)
    @params = params
  end

  def load
    if !@params[:query] || @params[:query].empty?
      load_ar
    else
      begin
        sermons = load_es
        
        # Trigger lazy load
        sermons.total_count
        sermons
      rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
        if (message = e.message.match(/QueryParsingException\[([^;]+)\]/).try(:[], 1))
          if @params[:advanced] && !@params[:advanced].empty?
            raise QueryParsingError, message
          else
            load_es(:simple_query_string)
          end
        else
          raise e
        end
      end
    end
  end

  class QueryParsingError < RrpcApi::Error; end

  private

  def load_ar
    Sermon
      .order(@@ar_orders[@params[:order]] || @@ar_orders['newest_first'])
      .page(@params[:page])
  end

  def load_es(mode = :query_string)
    SermonsIndex
      .query(mode => { query: @params[:query], default_operator: 'and' })
      .order(@@es_orders[@params[:order]] || @@es_orders['newest_first'])
      .page(@params[:page])
      .only(:id)
      .load
  end
end
