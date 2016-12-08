require 'sidekiq/scheduler'

Sidekiq.configure_server do |config|
  config.on :startup do
    Sidekiq.schedule = {
      ClearShrineCacheJob: { every: '12h' },
    }
    Sidekiq::Scheduler.reload_schedule!
  end
end
