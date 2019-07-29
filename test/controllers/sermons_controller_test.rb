require 'test_helper'

class SermonsControllerTest < ActionDispatch::IntegrationTest
  indexing :bypass
  assert_requires_auth :sermon, [:create, :update, :destroy]

  setup do
    @sermon = create(:sermon)
  end

  test 'should get index' do
    get sermon_index_url, as: :json
    assert_response :success

    get '/v0/sermon'
    assert_response :success
  end

  test 'should create sermon' do
    sermon = build(:sermon)
    assert_difference('Sermon.count') do
      post sermon_index_url,
           params: {
             access_key: Rails.application.secrets.admin_access_key,
             sermon: {
              audio: fixture_file_upload('test/fixtures/files/one-second-of-silence.mp3', 'audio/mpeg'),
              identifier: sermon.identifier,
              recorded_at: sermon.recorded_at,
              scripture_focus: sermon.scripture_focus,
              scripture_reading: sermon.scripture_reading,
              scripture_reading_might_be_focus: sermon.scripture_reading_might_be_focus,
              speaker_id: sermon.speaker.id,
              title: sermon.title,
            }
          }
      assert_response 201
    end
  end

  test 'should show sermon' do
    get sermon_url(@sermon), as: :json
    assert_response :success
  end

  test 'should update sermon' do
    patch sermon_url(@sermon),
          params: {
            access_key: Rails.application.secrets.admin_access_key,
            sermon: attributes_for(:sermon),
          }
    assert_response 200
  end

  test 'should destroy sermon' do
    assert_difference('Sermon.count', -1) do
      delete sermon_url(@sermon), params: {access_key: Rails.application.secrets.admin_access_key}, as: :json
      assert_response 204
    end
  end

  def sermon_index_url
    '/v0/sermons'
  end

  def sermon_url(sermon)
    "/v0/sermons/#{sermon.identifier}"
  end
end
