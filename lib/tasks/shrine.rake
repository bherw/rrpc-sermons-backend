namespace :shrine do
  desc "TODO"
  task migrate: :environment do
    Chewy.strategy :atomic do
      Sermon.find_each do |sermon|
        sermon.audio_attacher.promote(sermon.audio)
      end
    end
  end

  task rename: :environment do
    Chewy.strategy :atomic do
      Sermon.find_each do |sermon|
        if sermon.audio_attacher.stored?
          sermon.update(audio_data: sermon.audio_data.gsub('"store"', '"store_large"'))
        end
      end
    end
  end
end
