Sidekiq.configure_server do |config|
  config.redis = RrpcApi.sidekiq_redis_config
end

Sidekiq.configure_client do |config|
  config.redis = RrpcApi.sidekiq_redis_config
end
