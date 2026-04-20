# frozen_string_literal: true

require 'test_helper'

class EventThemeTest < ActiveSupport::TestCase
  setup do
    @params = {
      main_color: '#000000',
      overview: 'test',
      site_label: 'test',
      site_url: 'test',
      map_latitude: 35.681236,
      map_longitude: 139.767125,
      map_zoom: 13,
      beacon_share_radius_meters: 5000
    }
  end

  test 'should not save event theme without event' do
    event_theme = EventTheme.new(@pamars)
    assert_not event_theme.save
  end

  test 'should save event theme with event' do
    event = Event.new(name: 'test')
    event_theme = event.build_event_theme(@params)
    assert event_theme.save
  end

  test 'shareable location uses configured beacon radius meters' do
    event_theme = events(:kaigi).event_theme
    event_theme.update!(beacon_share_radius_meters: 1000)

    assert event_theme.shareable_location?(latitude: 33.839157, longitude: 132.765575)
    assert_not event_theme.shareable_location?(latitude: 33.850001, longitude: 132.780001)
  end
end
