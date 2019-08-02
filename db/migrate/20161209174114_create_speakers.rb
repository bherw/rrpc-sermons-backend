class CreateSpeakers < ActiveRecord::Migration[5.0]
  def change
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

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<~SQL
      INSERT INTO speakers (name, slug, created_at, updated_at)
      SELECT DISTINCT speaker_name, speaker_name, now(), now() FROM sermons;

      UPDATE sermons SET speaker_id = (SELECT id FROM speakers WHERE name = sermons.speaker_name);
    SQL

    # Generate slugs
    Chewy.strategy :bypass do
      Speaker.find_each do |speaker|
        speaker.slug = nil
        speaker.save!
      end
    end

    SpeakersIndex.reset!
  end
end
