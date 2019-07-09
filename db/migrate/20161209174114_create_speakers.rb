class CreateSpeakers < ActiveRecord::Migration[5.0]
  def up
    create_table :speakers do |t|
      t.string :name, null: false
      t.string :aliases, array: true, default: []
      t.text :photo_data
      t.text :description
      t.string :slug, null: false
    
      t.timestamps
    end
    add_index :speakers, :slug, unique: true
    add_index :speakers, :name, unique: true

    rename_column :sermons, :speaker, :speaker_name
    add_reference :sermons, :speaker, index: true
    add_foreign_key :sermons, :speakers

    Chewy.strategy :atomic do
      Sermon.find_each do |sermon|
        speaker = Speaker.find_by_name(sermon.speaker_name)
        if not speaker
          speaker = Speaker.new(name: sermon.speaker_name)
        end
        sermon.update(speaker: speaker)
      end
    end
  end

  def down
    remove_foreign_key :sermons, :speakers
    remove_reference :sermons, :speaker
    remove_index :speakers, :slug
    remove_index :speakers, :name
    drop_table :speakers

    rename_column :sermons, :speaker_name, :speaker
  end
end
