class Sermon < ApplicationRecord
  include SermonUploader[:audio]

  update_index 'sermons#sermon', :self

  validates :title, presence: true
  validates :scripture_reading, presence: true
  validates :speaker, presence: true
  validates :identifier, presence: true
  validates :recorded_at, presence: true

  belongs_to :speaker
  belongs_to :series, counter_cache: true, optional: true

  validate :that_series_has_the_same_speaker

  before_save do
    if series.nil?
      self.series_index = nil
    end
  end

  after_create do
    if !series.nil?
      series.update_indexes
      reload
    end
  end

  after_update do
    if saved_change_to_series_id?
      before, after = saved_change_to_series_id
      if before
        Series.find(before).update_indexes
      end
      if after
        series.update_indexes
        reload
      end
    end
  end

  after_destroy do
    if !series.nil?
      series.update_indexes
    end
  end

  def as_json(options)
    super(options.merge(except: [:audio_data], methods: [:audio_url, :audio_waveform_url, :duration]))
  end

  def audio_mime_type
    audio_original.mime_type
  end

  def audio_original
    audio.is_a?(Hash) ? audio[:original] : audio
  end

  def audio_url
    audio_original.url
  end

  def audio_size
    audio_original.size
  end

  def audio_waveform_url
    audio[:waveform].url if audio.is_a?(Hash)
  end

  def duration
    audio_original.duration
  end

  def scripture
    scripture_focus || scripture_reading
  end

  def slug
    identifier
  end

  def that_series_has_the_same_speaker
    if !series.nil? && series.speaker_id != speaker_id
      errors.add(:series, 'series speaker must be the same as sermon speaker')
    end
  end

  def title_with_series
    res = title
    res += " — " + series.name if !series.nil?
    res
  end

  def to_param
    identifier
  end
end
