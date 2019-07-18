require 'test_helper'

class SeriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @series = series(:one)
  end

  test "should get index" do
    get series_index_url, as: :json
    assert_response :success
  end

  test "should create series" do
    assert_difference('Series.count') do
      post series_index_url, params: { series: { name: @series.name, slug: @series.slug, speaker_id: @series.speaker_id } }, as: :json
    end

    assert_response 201
  end

  test "should show series" do
    get series_url(@series), as: :json
    assert_response :success
  end

  test "should update series" do
    patch series_url(@series), params: { series: { name: @series.name, slug: @series.slug, speaker_id: @series.speaker_id } }, as: :json
    assert_response 200
  end

  test "should destroy series" do
    assert_difference('Series.count', -1) do
      delete series_url(@series), as: :json
    end

    assert_response 204
  end
end
