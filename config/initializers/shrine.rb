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

conf = Rails.application.config.app
if conf['shrine_use_s3']
  s3_options = {
    access_key_id:     conf['s3_access_key_id'],
    secret_access_key: conf['s3_secret_access_key'],
    region:            conf['s3_region'],
    bucket:            conf['s3_bucket'],
  }

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store'),
    store_large: Shrine::Storage::S3.new(prefix: 'store', **s3_options),
  }

  Shrine.plugin :default_url_options,
    store: { host: RrpcApi.self_url },
    store_large: lambda do |io, **_options|
      {
        host: conf['s3_public_url'],
        response_content_disposition: "attachment; filename=\"#{io.original_filename}\"",
      }
    end
else
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store'),
  }
  Shrine.storages[:store_large] = Shrine.storages[:store]

  Shrine.plugin :default_url_options,
    store: { host: RrpcApi.self_url },
    store_large: { host: RrpcApi.self_url }
end
