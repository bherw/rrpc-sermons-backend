class PromoteJob
  include Sidekiq::Worker

  def perform(data)
    Chewy.strategy(:atomic) do
      Shrine::Attacher.promote(data)
    end
  end
end
