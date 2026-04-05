# frozen_string_literal: true

require 'test_helper'

class BeaconTest < ActiveSupport::TestCase
  test 'publish creates beacon with 30 minutes ttl' do
    travel_to Time.zone.parse('2026-04-05 12:00:00') do
      assert_difference('Beacon.count', 1) do
        beacon = Beacon.publish!(
          profile: profiles(:profile_four),
          event: events(:kaigi),
          latitude: 33.839157,
          longitude: 132.765575,
          accuracy_meters: 8
        )

        assert beacon.active?
        assert_equal 30.minutes.from_now, beacon.expires_at
      end
    end
  end

  test 'publish updates existing beacon for same profile and event' do
    travel_to Time.zone.parse('2026-04-05 13:00:00') do
      assert_no_difference('Beacon.count') do
        beacon = Beacon.publish!(
          profile: profiles(:profile_one),
          event: events(:kaigi),
          latitude: 33.850001,
          longitude: 132.780001
        )

        assert_equal beacons(:active_kaigi).id, beacon.id
        assert_equal 30.minutes.from_now, beacon.expires_at
      end
    end
  end

  test 'active scope excludes expired records' do
    assert_equal [beacons(:active_kaigi)], Beacon.active.on_event(events(:kaigi)).to_a
  end
end
