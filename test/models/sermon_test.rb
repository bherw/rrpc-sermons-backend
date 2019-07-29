require 'test_helper'

class SermonTest < ActiveSupport::TestCase
  indexing :bypass

  test "series index gets updated correctly" do
    series = create(:series)
    assert_equal 0, series.sermons_count

    # Create 1
    sermon = create(:sermon, { series: series, speaker: series.speaker, recorded_at: Time.now })
    assert_equal 1, series.sermons_count
    assert_equal 1, sermon.series_index

    # Create another after
    sermon2 = create(:sermon, { series: series, speaker: series.speaker, recorded_at: Time.now })
    assert_equal 2, series.sermons_count
    assert_equal 1, sermon.series_index
    assert_equal 2, sermon2.series_index

    # Create one before
    sermon0 = create(:sermon, { series: series, speaker: series.speaker, recorded_at: 1.day.ago })
    assert_equal 3, series.sermons_count
    assert_equal 1, sermon0.series_index
    assert_equal 2, sermon.reload.series_index
    assert_equal 3, sermon2.reload.series_index

    # Move to a different series
    series2 = create(:series, { speaker: series.speaker })
    sermon0.update!(series: series2)
    assert_equal 1, sermon.reload.series_index
    assert_equal 2, sermon2.reload.series_index
    assert_equal 1, sermon0.series_index

    # Destroy sermon
    sermon0.update!(series: series)
    assert_equal 1, sermon0.reload.series_index
    assert_equal 2, sermon.reload.series_index
    assert_equal 3, sermon2.reload.series_index
    sermon0.destroy!
    assert_equal 1, sermon.reload.series_index
    assert_equal 2, sermon2.reload.series_index

    # Remove from series
    sermon.update!(series: nil)
    assert_nil sermon.reload.series_index
    assert_equal 1, sermon2.reload.series_index
  end
end
