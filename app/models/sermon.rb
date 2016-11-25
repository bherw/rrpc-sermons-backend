class Sermon < ApplicationRecord
  include SermonUploader[:audio]

  def as_json(_opts)
    super except: [:audio_data], methods: [:audio_url, :audio_waveform_url, :duration]
  end

  def audio_url
    if audio.is_a?(Hash)
      audio[:original].url
    else
      audio.url
    end
  end

  def audio_waveform_url
    audio[:waveform].url if audio.is_a?(Hash)
  end

  def duration
    if audio.is_a?(Hash)
      audio[:original].duration
    else
      audio.duration
    end
  end

  def to_param
    identifier
  end
end
