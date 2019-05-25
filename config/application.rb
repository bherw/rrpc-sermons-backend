require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
# require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
# require 'action_mailer/railtie'
# require 'action_view/railtie'
# require 'action_cable/engine'
# require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RrpcApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.app = config_for(:app)
  end

  class Error < StandardError; end
  class NotAuthorizedError < Error; end

  def self.audio_peaks_resolution
    Rails.configuration.app.fetch('audio_peaks_resolution') { 4096 }
  end

  def self.mp3_prefix
    Rails.configuration.app.fetch('mp3_prefix') { '' }
  end

  def self.self_url
    Rails.configuration.app.fetch('self_url')
  end

  def self.sidekiq_redis_config
    Rails.configuration.app.fetch('sidekiq_redis_config') do
      { url: 'redis://localhost:6379/0', namespace: "rrpc_api_sidekiq_#{Rails.env}" }
    end
  end

  def self.webapp_url
    Rails.configuration.app.fetch('webapp_url')
  end
end
