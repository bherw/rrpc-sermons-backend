class Sermon < ApplicationRecord
  include SermonUploader[:audio_file]

  def as_json(_opts)
    super except: [:audio_file_data], methods: [:audio_file_url, :audio_waveform_url, :duration]
  end

  def audio_file_url
    if audio_file.is_a?(Hash)
      audio_file[:original].url
    else
      audio_file.url
    end
  end

  def audio_waveform_url
    audio_file[:waveform].url if audio_file.is_a?(Hash)
  end

  def duration
    if audio_file.is_a?(Hash)
      audio_file[:original].duration
    else
      audio_file.duration
    end
  end

  def to_param
    identifier
  end
end
