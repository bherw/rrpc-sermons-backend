require 'test_helper'

class SpeakersControllerTest < ActionDispatch::IntegrationTest
  indexing :bypass
  assert_requires_auth :speaker, [:create, :update, :destroy]

  setup do
    @speaker = create(:speaker)
  end

  test "should get index" do
    get speaker_index_url, as: :json
    assert_response :success
  end

  test "should create speaker" do
    assert_difference('Speaker.count') do
      post speaker_index_url,
           params: {
             access_key: Rails.application.secrets.admin_access_key,
             speaker: attributes_for(:speaker)
           },
           as: :json

      assert_response 201
    end
  end

  test "should show speaker" do
    get speaker_url(@speaker), as: :json
    assert_response :success
  end

  test "should update speaker" do
    patch speaker_url(@speaker),
          params: {
            access_key: Rails.application.secrets.admin_access_key,
            speaker: attributes_for(:speaker)
          },
          as: :json

    assert_response 200
  end

  test "should destroy speaker" do
    assert_difference('Speaker.count', -1) do
      delete speaker_url(@speaker),
             params: { access_key: Rails.application.secrets.admin_access_key },
             as: :json
      assert_response 204
    end
  end

  def speaker_index_url
    '/v0/speakers'
  end

  def speaker_url(speaker)
    "/v0/speakers/#{speaker.slug}"
  end
end
