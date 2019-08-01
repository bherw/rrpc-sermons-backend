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


    Chewy.strategy :atomic do
      Sermon.find_each do |sermon|
        if sermon.series_name
          series = Series.find_by_name(sermon.series_name)
          if not series
            series = Series.create(name: sermon.series_name, speaker: sermon.speaker)
          end
          sermon.update_columns(series_id: series.id)
        end
      end
    end

    remove_column :sermons, :series_name
  end

  def down
    add_column :sermons, :series_name, :string

    Chewy.strategy :atomic do
      Sermon.find_each do |sermon|
        if sermon.series
          sermon.update_columns(series_name: sermon.series.name)
        end
      end
    end

    remove_foreign_key :sermons, :series
    remove_reference :sermons, :series
    remove_index :series, :slug
    drop_table :series
    rename_column :sermons, :series_name, :series
  end
end
