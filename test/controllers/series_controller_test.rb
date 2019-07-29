require 'test_helper'

class SeriesControllerTest < ActionDispatch::IntegrationTest
  indexing :bypass
  assert_requires_auth :series, [:create, :update, :destroy]

  setup do
    @series = create(:series)
    @speaker = create(:speaker)
  end

  test "should get index" do
    get series_index_url, as: :json
    assert_response :success
  end

  test "should create series" do
    new_series = build(:series)
    assert_difference('Series.count') do
      post series_index_url,
           params: {
             access_key: Rails.application.secrets.admin_access_key,
             series: {
               name: new_series.name,
               speaker_id: @speaker.id
             }
           },
           as: :json

      assert_response 201
    end

    @series = Series.find_by(name: @series.name)
  end

  test "should show series" do
    get series_url(@series), as: :json
    assert_response :success
  end

  test "should update series" do
    patch series_url(@series),
          params: {
            access_key: Rails.application.secrets.admin_access_key,
            series: {
              name: @series.name,
              speaker_id: @speaker.id
            }
          },
          as: :json
    assert_response 200
  end

  test "should destroy series" do
    assert_difference('Series.count', -1) do
      delete series_url(@series), params: { access_key: Rails.application.secrets.admin_access_key }, as: :json
      assert_response 204
    end
  end

  def series_index_url
    '/v0/series'
  end

  def series_url(series)
    "/v0/series/#{series.slug}"
  end
end
