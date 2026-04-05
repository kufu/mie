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
      map_zoom: 13
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
end
