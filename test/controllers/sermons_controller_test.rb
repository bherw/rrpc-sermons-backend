require 'test_helper'

class SermonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sermon = sermons(:one)
  end

  test 'should get index' do
    get sermons_url, as: :json
    assert_response :success
  end

  test 'should create sermon' do
    assert_difference('Sermon.count') do
      post sermons_url,
           params: {
             audio_file_data: @sermon.audio_file_data,
             identifier: @sermon.identifier,
             recorded_at: @sermon.recorded_at,
             scripture_focus: @sermon.scripture_focus,
             scripture_reading: @sermon.scripture_reading,
             scripture_reading_might_be_focus: @sermon.scripture_reading_might_be_focus,
             series: @sermon.series,
             speaker: @sermon.speaker,
             title: @sermon.title,
           },
           as: :json
    end

    assert_response 201
  end

  test 'should show sermon' do
    get sermon_url(@sermon), as: :json
    assert_response :success
  end

  test 'should update sermon' do
    patch sermon_url(@sermon),
          params: {
            audio_file_data: @sermon.audio_file_data,
            identifier: @sermon.identifier,
            recorded_at: @sermon.recorded_at,
            scripture_focus: @sermon.scripture_focus,
            scripture_reading: @sermon.scripture_reading,
            scripture_reading_might_be_focus: @sermon.scripture_reading_might_be_focus,
            series: @sermon.series,
            speaker: @sermon.speaker,
            title: @sermon.title,
          },
          as: :json
    assert_response 200
  end

  test 'should destroy sermon' do
    assert_difference('Sermon.count', -1) do
      delete sermon_url(@sermon), as: :json
    end

    assert_response 204
  end
end
