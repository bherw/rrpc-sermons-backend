class CreateSermons < ActiveRecord::Migration[5.0]
  def change
    create_table :sermons do |t|
      t.text :audio_file_data
      t.string :identifier
      t.datetime :recorded_at
      t.string :series
      t.string :title
      t.string :scripture_focus
      t.string :scripture_reading
      t.boolean :scripture_reading_might_be_focus
      t.string :speaker

      t.timestamps
    end
  end
end
