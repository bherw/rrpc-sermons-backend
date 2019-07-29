class AddSermonsCountColumnToSeries < ActiveRecord::Migration[5.2]
  def up
    add_column :series, :sermons_count, :int, null: false, default: 0

    # Avoid rails validation to initialize this readonly field.
    Series.includes(:sermons).find_each do |series|
      Series.where(id: series.id).update_all(sermons_count: Sermon.where(series_id: series.id).count)
    end
  end

  def down
    remove_column :series, :sermons_count
  end
end
