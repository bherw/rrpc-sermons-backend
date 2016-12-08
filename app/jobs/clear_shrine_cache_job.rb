class ClearShrineCacheJob
  include Sidekiq::Worker

  def perform
    Chewy.strategy(:atomic) do
      begin
        Shrine.storages[:cache].clear!(older_than: Time.now - 24*60*60)
      rescue ::Error::ENOENT => _
      end
    end
  end
end