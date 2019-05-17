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
  require 'shrine/storage/s3'

  s3_options = {
    public:            true,
    access_key_id:     Rails.application.secrets.s3_access_key_id,
    secret_access_key: Rails.application.secrets.s3_secret_access_key,
    region:            conf['s3_region'],
    bucket:            conf['s3_bucket'],
  }

  Shrine.storages = {
    cache:       Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store_large: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store'),
    store:       Shrine::Storage::S3.new(prefix: 'store', **s3_options),
  }

  Shrine.plugin :default_url_options,
                store_large: { host: RrpcApi.self_url },
                store: lambda { |io, **_options|
                  { response_content_disposition: ContentDisposition.attachment(io.original_filename) }
                }
else
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store'),
  }
  Shrine.storages[:store_large] = Shrine.storages[:store]

  Shrine.plugin :default_url_options,
                store:       { host: RrpcApi.self_url },
                store_large: { host: RrpcApi.self_url }
end
