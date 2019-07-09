require 'test_helper'

class SpeakersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @speaker = speakers(:one)
  end

  test "should get index" do
    get speakers_url, as: :json
    assert_response :success
  end

  test "should create speaker" do
    assert_difference('Speaker.count') do
      post speakers_url, params: { speaker: { description: @speaker.description, name: @speaker.name, photo: @speaker.photo, synonyms: @speaker.synonyms } }, as: :json
    end

    assert_response 201
  end

  test "should show speaker" do
    get speaker_url(@speaker), as: :json
    assert_response :success
  end

  test "should update speaker" do
    patch speaker_url(@speaker), params: { speaker: { description: @speaker.description, name: @speaker.name, photo: @speaker.photo, synonyms: @speaker.synonyms } }, as: :json
    assert_response 200
  end

  test "should destroy speaker" do
    assert_difference('Speaker.count', -1) do
      delete speaker_url(@speaker), as: :json
    end

    assert_response 204
  end
end
