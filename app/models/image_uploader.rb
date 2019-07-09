class ImageUploader < Shrine
  plugin :add_metadata
  plugin :determine_mime_type
  plugin :validation_helpers
end