source 'https://rubygems.org'

# Core
gem 'puma', '~> 4.3'
gem 'rails', '~> 5.0'
gem 'addressable', '~> 2.5' # Address logic

# Database
gem 'elasticsearch', '~> 5.0'
gem 'chewy', '~> 5.0'
gem 'pg', '~> 0.19'
gem 'redis-namespace', '~> 1.5'

# Background tasks
gem 'sidekiq', '~> 5.0'
gem 'sidekiq-scheduler', '~> 3.0'

# Attachments
gem 'aws-sdk-s3', '~> 1.39'
gem 'shrine', '~> 2.5'
gem 'taglib-ruby', '~> 0.7' # audio file duration metadata

# Misc
gem 'curb', '~> 0.9' # Biblesearch proxy
gem 'friendly_id', '~> 5.2.4' # slug-urls
gem 'graphql', '~> 1.9'
gem 'graphql-batch', '~> 0.4.3'
gem 'kaminari', '~> 1.2' # Pagination

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
