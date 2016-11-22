class PromoteJob
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(data)
    Shrine::Attacher.promote(data)
  end
end
