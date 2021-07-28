# frozen_string_literal: true

require 'test_helper'

class SchedulesHelperTest < ActionView::TestCase
  test 'create_table_array' do
    schs = schedules(:one, :two, :three, :four, :five)

    expect = {
      '2021-07-20' => [
        [nil, 'TrackA', 'TrackB'],
        ['10:00:00 - 10:40:00', schs[0], nil],
        ['11:00:00 - 11:40:00', nil, schs[1]]
      ],
      '2021-07-21' => [
        [nil, 'TrackA', 'TrackB', 'TrackC'],
        ['10:00:00 - 10:40:00', schs[2], nil, nil],
        ['11:00:00 - 11:40:00', nil, schs[3], schs[4]]
      ]
    }
    assert_equal expect, create_table_array(schs)
  end
end
