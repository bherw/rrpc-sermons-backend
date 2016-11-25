# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# We use an access token so CORS is not an issue.
use Rack::Header, 'Access-Control-Allow-Origin' => '*'

run Rails.application
