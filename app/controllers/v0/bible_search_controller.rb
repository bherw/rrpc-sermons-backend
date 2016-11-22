require 'curb'

module V0
  class BibleSearchController < ApplicationController
    def query # TODO: correct return status code for errors
      render(**proxied_query)
    end

    private

    def proxied_query
      Rails.cache.fetch("bible_search/#{params[:query]}?#{request.query_string}",
                        expires_in: 14.days) do
        proxied_query!
      end
    end

    def proxied_query!
      c = Curl::Easy.new("https://bibles.org/v2/#{params[:query]}?#{request.query_string}")
      c.follow_location = true
      c.http_auth_types = :basic
      c.username        = Rails.application.secrets.bible_search_access_key
      c.password        = 'X'
      c.perform

      { status: c.response_code, content_type: c.content_type, body: c.body_str }
    end
  end
end
