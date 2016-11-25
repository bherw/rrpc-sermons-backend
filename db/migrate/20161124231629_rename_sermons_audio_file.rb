class RenameSermonsAudioFile < ActiveRecord::Migration[5.0]
  def change
    rename_column :sermons, :audio_file_data, :audio_data
  end
end
