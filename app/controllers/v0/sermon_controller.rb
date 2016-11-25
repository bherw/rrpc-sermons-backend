require 'active_support/builder'

module V0
  class SermonController < ApplicationController
    include ActionController::MimeResponds
    include ActionView::Helpers::AtomFeedHelper

    before_action :set_sermon, only: [:show, :update, :destroy]

    # GET /sermon
    def index
      @sermons = Sermon.all

      respond_to do |format|
        format.json { render_json results: @sermons, total: @sermons.length }
        format.atom { render xml: index_atom }
      end
    end

    # GET /sermon/1
    def show
      render_json @sermon
    end

    # POST /sermon
    def create
      @sermon = Sermon.new(sermon_params)
      authorize @sermon

      if @sermon.save
        render json: { data: @sermon }, status: :created, location: @sermon
      else
        render json: { errors: @sermon.errors }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /sermon/1
    def update
      authorize @sermon
      if @sermon.update(sermon_params)
        render json: { data: @sermon }
      else
        render json: { errors: @sermon.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /sermon/1
    def destroy
      authorize @sermon
      @sermon.destroy
    end

    private

    def index_atom
      url = ::Addressable::URI.parse(frontend_url_for('/sermon'))
      url.query_values = request.GET
      atom_feed(root_url: url, xml: Builder::XmlMarkup.new) do |feed|
        feed.title('RRPC Sermons')
        feed.updated(@sermons[0].created_at) unless @sermons.empty?

        @sermons.each do |sermon|
          feed.entry(sermon, url: frontend_url_for("/sermon/#{sermon.identifier}")) do |entry|
            entry.title(sermon.title)
            entry.content(sermon.title + '<br>' +
                          sermon.scripture_reading + '<br>' +
                          sermon.speaker + '<br>' +
                          sermon.recorded_at.to_formatted_s(:long),
                          type: 'html')

            entry.author do |author|
              author.name(sermon.speaker)
            end

            entry.link(href: sermon.audio_file_url,
                       rel:  'enclosure',
                       type: sermon.audio_file[:original].mime_type)
          end
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_sermon
      @sermon = Sermon.find_by!(identifier: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sermon_params
      params.permit(:audio, :identifier, :recorded_at, :series, :title, :scripture_focus,
                    :scripture_reading, :scripture_reading_might_be_focus, :speaker)
    end

    def sermon_url(sermon)
      url_for "v0/sermon/#{sermon.identifier}"
    end
  end
end
