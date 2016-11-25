class DeleteJob
  include Sidekiq::Worker

  def perform(data)
    Chewy.strategy(:atomic) do
      Shrine::Attacher.delete(data)
    end
  end
end
