require 'active_support/builder'

module V0
  class SermonController < ApplicationController
    include ActionController::MimeResponds
    include ActionView::Helpers::AtomFeedHelper

    before_action :set_sermon, only: [:show, :update, :destroy]

    # GET /sermon
    def index
      @sermons = SermonSearch.new(params).load

      respond_to do |format|
        format.json { render_json results: @sermons, total: @sermons.total_count }
        format.atom { render xml: index_atom }
        format.rss { render xml: index_rss }
      end
    rescue SermonSearch::QueryParsingError => e
      render json: { errors: e.message }
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
            content = '<p>' + sermon.title_with_series + '<br>' +
                          sermon.scripture_reading + '<br>' +
                          sermon.speaker + '<br>' +
                          sermon.recorded_at.to_formatted_s(:long) + '</p>'
            entry.content(content, 'html')

            entry.author do |author|
              author.name(sermon.speaker)
            end

            entry.link(href: sermon.audio_url,
                       rel:  'enclosure',
                       type: sermon.audio_mime_type)
          end
        end
      end
    end

    def index_rss
      title = "Russell Reformed Presbyterian Church Sermons"
      description = "Sermons preached every Lord's Day, morning and evening, at the Russell Reformed Presbyterian Church"
      image = frontend_url_for("/podcast-image.png")
      author = "Russell RPC"
      email = "contact@russellrpc.org"
      keywords = "russell,reformed,presbyterian,church,sermon,christian,scripture,bible,rpc,rrpc"

      xml = ::Builder::XmlMarkup.new()
      xml.instruct! :xml, :version => "1.0"
      xml.rss :version => "2.0", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", "xmlns:media" => "http://search.yahoo.com/mrss/", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
        xml.channel do
          xml.tag!("atom:link", "href" => url_for(:only_path => false), "rel" => "self", "type" => "application/rss+xml")
          xml.title title
          xml.link frontend_url()
          xml.description description
          xml.language 'en'
          xml.pubDate @sermons.first.created_at.to_s(:rfc822)
          xml.lastBuildDate @sermons.first.created_at.to_s(:rfc822)
          xml.itunes :author, author
          xml.itunes :keywords, keywords
          xml.itunes :explicit, 'clean'
          xml.itunes :image, :href => image
          xml.itunes :owner do
            xml.itunes :name, author
            xml.itunes :email, email
          end
          xml.itunes :block, 'no'
          xml.itunes :category, :text => 'Religion & Spirituality' do
            xml.itunes :category, :text => 'Christianity'
          end

          @sermons.each do |sermon|
            xml.item do
              description = "Scripture reading: " + sermon.scripture
              url = frontend_url_for("/sermon/#{sermon.identifier}")

              xml.title sermon.title_with_series
              xml.description description
              xml.pubDate sermon.recorded_at.to_s(:rfc822)
              xml.enclosure :url => sermon.audio_url, :length => sermon.audio_size, :type => sermon.audio_mime_type
              xml.link url
              xml.guid({:isPermaLink => "false"}, url)
              xml.author sermon.speaker
              xml.itunes :author, sermon.speaker
              xml.itunes :subtitle, description.truncate(150)
              xml.itunes :summary, description
              xml.itunes :explicit, 'no'
              xml.itunes :duration, sermon.duration
            end
          end
        end
      end
    end

    def frontend_url
      url = ::Addressable::URI.parse(frontend_url_for('/sermon'))
      url.query_values = request.GET
      url
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
