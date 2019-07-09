module V0
  class SpeakersController < ApplicationController
    before_action :set_speaker, only: [:show, :update, :destroy]

    # GET /speaker
    def index
      @speakers = Speaker.all

      render json: @speakers
    end

    # GET /speaker/1
    def show
      render json: { data: @sermon }
    end

    # POST /speaker
    def create
      @speaker = Speaker.new(speaker_params)
      authorize @speaker

      if @speaker.save
        render json: { data: @sermon }, status: :created, location: @speaker
      else
        render json: { errors: @speaker.errors }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /speaker/1
    def update
      authorize @speaker
      if @speaker.update(speaker_params)
        render json: { data: @sermon }
      else
        render json: { errors: @speaker.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /speaker/1
    def destroy
      authorize @speaker
      @speaker.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_speaker
      @speaker = params[:id] =~ /^\d+$/ ? Speaker.find(params[:id]) : Speaker.friendly.find(slug: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def speaker_params
      params.require(:speaker).permit(:name, :aliases, :photo, :description)
    end
  end
end
