include ActiveSupport::SecurityUtils

class ApplicationController < ActionController::API
  rescue_from RrpcApi::NotAuthorizedError, with: :render_not_authorized

  def authorize(_what)
    access_key = Rails.application.secrets.admin_access_key
    raise RuntimeError, "Missing secrets.admin_access_key" unless !access_key.nil? && !access_key.empty?
    raise RrpcApi::NotAuthorizedError unless secure_compare(access_key, params[:access_key].to_s)
  end

  # Because we might be at api.foo.com or foo.com/api
  def default_url_options
    { host: RrpcApi.self_url }
  end

  def frontend_url_for(options)
    case options
    when String
      RrpcApi.webapp_url + options
    when Hash
      options = options.symbolize_keys
      options[:host] ||= RrpcApi.webapp_url
      url_for options
    else
      url_for options
    end
  end

  def render_json(value)
    render json: { data: value }
  end

  def render_not_authorized
    render json: { errors: ['Not Authorized'] }, status: :forbidden
  end
end
