require 'shrine'
require 'shrine/storage/file_system'

Shrine.plugin :activerecord
Shrine.plugin :backgrounding
Shrine.plugin :delete_promoted
Shrine.plugin :logging, logger: Rails.logger
Shrine.plugin :moving
Shrine.plugin :pretty_location

Shrine::Attacher.promote { |data| PromoteJob.perform_async(data) }
Shrine::Attacher.delete { |data| DeleteJob.perform_async(data) }

if Rails.env.production?
  s3_options = {
    access_key_id:     ENV['S3_ACCESS_KEY_ID'],
    secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],
    region:            ENV['S3_REGION'],
    bucket:            ENV['S3_BUCKET'],
  }

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::S3.new(prefix: 'store', **s3_options),
  }

  Shrine.plugin :default_url_options, store: lambda do |io, **_options|
    {
      host: ENV['DEFAULT_URL_HOST'],
      response_content_disposition: "attachment; filename=\"#{io.original_filename}\"",
    }
  end
else
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store'),
  }

  Shrine.plugin :default_url_options, store: { host: ENV['DEFAULT_URL_HOST'] }
end
