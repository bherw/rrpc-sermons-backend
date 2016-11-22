require 'taglib'
require 'tempfile'
require 'json'

class SermonUploader < Shrine
  plugin :add_metadata
  plugin :determine_mime_type
  plugin :processing
  plugin :validation_helpers
  plugin :versions

  Attacher.validate do
    validate_max_size 50.megabytes
    validate_mime_type_inclusion ['audio/mpeg']
  end

  add_metadata :duration do |io, _context|
    ::TagLib::FileRef.open(io.path) do |file|
      file.audio_properties.length unless file.null?
    end
  end

  process :store do |io, _context|
    original = io.download
    original_path = File.readlink("/proc/self/fd/#{original.fileno}")

    tmp = Tempfile.new(['audio', '.json'])
    unless system 'audiowaveform',
                  '-i', original_path,
                  '-o', tmp.path,
                  '--pixels-per-second',
                  (io.duration.to_f / RrpcApi.audio_peaks_resolution).ceil.to_s
      raise AudioWaveformGenerationError "Can't generate from " + original_path
    end
    json = JSON.parse(tmp.read)
    waveform = Tempfile.new(['waveform', '.dat'], binmode: true)
    waveform.write(json['data'].pack('s*'))

    { original: original, waveform: waveform }
  end
  class AudioWaveformGenerationError; end
end
