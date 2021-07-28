# frozen_string_literal: true

require 'test_helper'

class ReactHelperTest < ActionView::TestCase
  test 'schedule_to_card_props' do
    sch = schedules(:one)
    expect = {
      title: sch.title,
      description: sch.description,
      speakerName: sch.speaker.name,
      thumbnailUrl: sch.speaker.thumbnail,
      language: sch.language
    }
    assert_equal expect, schedule_to_card_props(sch)
  end

  test 'create_schedule_table_props' do
    schs = schedules(:one, :two, :three, :four, :five)
    table_array = Class.new { include SchedulesHelper }.new.create_table_array(schs)

    expect = {
      '2021-07-20' => {
        trackList: %w[TrackA TrackB],
        rows: [
          { time: '10:00:00 - 10:40:00', schedules: [schedule_to_card_props(schs[0]), nil] },
          { time: '11:00:00 - 11:40:00', schedules: [nil, schedule_to_card_props(schs[1])] }
        ]
      },
      '2021-07-21' => {
        trackList: %w[TrackA TrackB TrackC],
        rows: [
          { time: '10:00:00 - 10:40:00', schedules: [schedule_to_card_props(schs[2]), nil, nil] },
          { time: '11:00:00 - 11:40:00',
            schedules: [nil, schedule_to_card_props(schs[3]), schedule_to_card_props(schs[4])] }
        ]
      }
    }
    assert_equal expect, create_schedule_table_props(table_array)
  end
end
