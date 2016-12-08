class ClearShrineCacheJob
  include Sidekiq::Worker

  def perform
    Chewy.strategy(:atomic) do
      begin
        Shrine.storages[:cache].clear!(older_than: Time.current - 24.hours)
      rescue ::Error::ENOENT => _
      end
    end
  end
end
