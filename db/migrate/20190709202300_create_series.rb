class CreateSeries < ActiveRecord::Migration[5.2]
  def up
    create_table :series do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.references :speaker, foreign_key: true, null: false

      t.timestamps
    end
    add_index :series, :slug, unique: true

    rename_column :sermons, :series, :series_name
    add_reference :sermons, :series
    add_foreign_key :sermons, :series

    reversible do |dir|
      dir.up { data }
    end

    remove_column :sermons, :series_name
  end

  def data
    execute <<~SQL
      INSERT INTO series (name, speaker_id, slug, created_at, updated_at)
      SELECT DISTINCT series_name, speaker_id, series_name, now(), now() FROM sermons WHERE series_name IS NOT NULL;

      UPDATE sermons SET series_id = (
        SELECT id FROM series WHERE name = sermons.series_name AND series.speaker_id = sermons.speaker_id
      );
    SQL

    # Generate slugs
    Chewy.strategy :bypass do
      Series.find_each do |series|
        series.slug = nil
        series.save!
      end
    end

    SeriesIndex.reset!
  end
end
