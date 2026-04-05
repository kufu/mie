# frozen_string_literal: true

require 'test_helper'

class MapsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:kaigi)
  end

  test 'should get map when logged in' do
    old_api_key = ENV['GOOGLE_MAPS_API_KEY']
    ENV['GOOGLE_MAPS_API_KEY'] = 'test-key'

    omniauth_callback_uid('1234')
    get '/auth/github/callback'

    get event_map_url(event_name: @event.name)
    assert_response :success
    assert_includes @response.body, 'test-key'
  ensure
    ENV['GOOGLE_MAPS_API_KEY'] = old_api_key
  end

  test 'should redirect map when not logged in' do
    get event_map_url(event_name: @event.name)
    assert_redirected_to profile_path
  end
end
