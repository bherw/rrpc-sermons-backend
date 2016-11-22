class ApplicationController < ActionController::API
  rescue_from RrpcApi::NotAuthorizedError, with: :render_not_authorized

  def authorize(_what)
    access_key = params[:access_key]
    secrets = Rails.application.secrets
    raise RrpcApi::NotAuthorizedError unless access_key == secrets.admin_access_key
  end

  def default_url_options
    { host: ENV['DEFAULT_URL_HOST'] }
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
