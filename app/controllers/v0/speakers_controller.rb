module V0
  class SpeakersController < ApplicationController
    before_action :set_speaker, only: [:show, :update, :destroy]

    # GET /v0/speakers
    def index
      @speakers = Speaker.all

      render json: @speakers
    end

    # GET /v0/speakers/1
    def show
      render json: { data: @sermon }
    end

    # POST /v0/speakers
    def create
      @speaker = Speaker.new(speaker_params)
      authorize @speaker

      if @speaker.save
        render json: { data: @sermon }, status: :created, location: @speaker
      else
        render json: { errors: @speaker.errors }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /v0/speakers/1
    def update
      authorize @speaker
      if @speaker.update(speaker_params)
        render json: { data: @sermon }
      else
        render json: { errors: @speaker.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /v0/speakers/1
    def destroy
      authorize @speaker
      @speaker.destroy
    end

    private
    def set_speaker
      @speaker = Speaker.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def speaker_params
      params.require(:speaker).permit(:name, :aliases, :photo, :description)
    end

    def speaker_url(speaker)
      "v0/speakers/#{speaker.slug}"
    end
  end
end
