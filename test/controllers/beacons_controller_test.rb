# frozen_string_literal: true

require 'test_helper'

class BeaconsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:kaigi)
  end

  test 'should list only active beacons for event' do
    omniauth_callback_uid('1234')
    get '/auth/github/callback'

    get event_beacons_url(event_name: @event.name, format: :json)
    assert_response :success

    assert_equal [beacons(:active_kaigi).id], response.parsed_body['beacons'].map { it['id'] }
    assert_equal beacons(:active_kaigi).id, response.parsed_body['current_beacon']['id']
  end

  test 'should publish beacon for current user' do
    omniauth_callback_uid('13141516')
    get '/auth/github/callback'
    access_key = beacon_access_key_for(@event)

    travel_to Time.zone.parse('2026-04-05 16:00:00') do
      assert_difference('Beacon.count', 1) do
        post event_beacon_url(event_name: @event.name, format: :json), params: {
          beacon: {
            latitude: 33.839157,
            longitude: 132.765575,
            accuracy_meters: 12
          }
        }, headers: beacon_headers(access_key), as: :json
      end

      assert_response :success
      assert response.parsed_body['access_key'].present?
      refute_equal access_key, response.parsed_body['access_key']

      beacon = Beacon.find_by!(profile: profiles(:profile_four), event: @event)
      assert_in_delta 33.839157, beacon.latitude.to_f, 0.000001
      assert_in_delta 132.765575, beacon.longitude.to_f, 0.000001
      assert_equal 12, beacon.accuracy_meters
      assert_equal 30.minutes.from_now, beacon.expires_at
    end
  end

  test 'should update existing beacon instead of creating a new one' do
    omniauth_callback_uid('1234')
    get '/auth/github/callback'
    access_key = beacon_access_key_for(@event)

    travel_to Time.zone.parse('2026-04-05 17:00:00') do
      assert_no_difference('Beacon.count') do
        post event_beacon_url(event_name: @event.name, format: :json), params: {
          beacon: {
            latitude: 33.850001,
            longitude: 132.780001,
            accuracy_meters: 20
          }
        }, headers: beacon_headers(access_key), as: :json
      end

      assert_response :success
      assert response.parsed_body['access_key'].present?
      refute_equal access_key, response.parsed_body['access_key']

      beacon = beacons(:active_kaigi).reload
      assert_in_delta 33.850001, beacon.latitude.to_f, 0.000001
      assert_in_delta 132.780001, beacon.longitude.to_f, 0.000001
      assert_equal 20, beacon.accuracy_meters
      assert_equal 30.minutes.from_now, beacon.expires_at
    end
  end

  test 'should delete beacon for current user and event' do
    omniauth_callback_uid('1234')
    get '/auth/github/callback'

    assert_difference('Beacon.count', -1) do
      delete event_beacon_url(event_name: @event.name, format: :json), as: :json
    end

    assert_response :no_content
  end

  test 'should reject beacon publish without beacon access key' do
    omniauth_callback_uid('13141516')
    get '/auth/github/callback'

    assert_no_difference('Beacon.count') do
      post event_beacon_url(event_name: @event.name, format: :json), params: {
        beacon: {
          latitude: 33.839157,
          longitude: 132.765575,
          accuracy_meters: 12
        }
      }, as: :json
    end

    assert_response :forbidden
    assert_includes response.parsed_body['errors'], I18n.t('errors.invalid_beacon_access_key')
  end

  test 'should reject reused beacon access key' do
    omniauth_callback_uid('13141516')
    get '/auth/github/callback'
    access_key = beacon_access_key_for(@event)

    post event_beacon_url(event_name: @event.name, format: :json), params: {
      beacon: {
        latitude: 33.839157,
        longitude: 132.765575,
        accuracy_meters: 12
      }
    }, headers: beacon_headers(access_key), as: :json
    assert_response :success

    assert_no_difference('Beacon.count') do
      post event_beacon_url(event_name: @event.name, format: :json), params: {
        beacon: {
          latitude: 33.840157,
          longitude: 132.766575,
          accuracy_meters: 10
        }
      }, headers: beacon_headers(access_key), as: :json
    end

    assert_response :forbidden
    assert_includes response.parsed_body['errors'], I18n.t('errors.invalid_beacon_access_key')
  end

  test 'should redirect when not logged in' do
    get event_beacons_url(event_name: @event.name, format: :json)
    assert_redirected_to profile_path
  end

  private

  def beacon_access_key_for(event)
    get event_map_url(event_name: event.name)
    response.body[/data-beacon-map-access-key-value="([^"]+)"/, 1]
  end

  def beacon_headers(access_key)
    { 'X-Beacon-Access-Key' => access_key }
  end
end
