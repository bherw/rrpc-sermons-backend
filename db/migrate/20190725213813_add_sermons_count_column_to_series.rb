class AddSermonsCountColumnToSeries < ActiveRecord::Migration[5.2]
  def change
    add_column :series, :sermons_count, :int, null: false, default: 0

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
      UPDATE series SET sermons_count = (SELECT count(1) FROM sermons WHERE sermons.series_id = series.id)
    SQL
  end
end
