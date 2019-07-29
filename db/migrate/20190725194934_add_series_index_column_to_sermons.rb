class AddSeriesIndexColumnToSermons < ActiveRecord::Migration[5.2]
  def up
    add_column :sermons, :series_index, :int

    Chewy.strategy :atomic do
      Series.includes(:sermons).find_each do |series|
        series.update_indexes
      end
    end
  end

  def down
    remove_column :sermons, :series_index
  end
end
