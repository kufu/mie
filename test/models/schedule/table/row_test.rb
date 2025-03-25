# frozen_string_literal: true

require 'test_helper'

class Schedule
  class Table
    class RowTest < ActiveSupport::TestCase
      test '#== can compare two rows equality' do
        assert Schedule::Tables.from_event(events(:kaigi)).tables.first.rows.first == Schedule::Tables.from_event(events(:kaigi)).tables.first.rows.first
      end

      test '#== can compare two rows not equality' do
        assert Schedule::Tables.from_event(events(:kaigi)).tables.first.rows.first != Schedule::Tables.from_event(events(:kaigi)).tables.first.rows.second
      end

      test 'each rows mapping correct track infomations with fixture' do
        schedules = events(:kaigi).schedules
        tables = Schedule::Tables.new(schedules)

        day1 = tables['2024-03-18']

        assert_equal day1.rows[0].start_end, '10:00 - 10:30'
        assert_equal day1.rows[0].tracks['TrackA'], schedules(:kaigi_day1_time1_track1)

        assert_equal day1.rows[1].start_end, '10:40 - 11:00'
        assert_equal day1.rows[1].tracks['TrackA'], schedules(:kaigi_day1_time2_track1)
        assert_equal day1.rows[1].tracks['TrackB'], schedules(:kaigi_day1_time2_track2)
        assert_equal day1.rows[1].tracks['TrackC'], schedules(:kaigi_day1_time2_track3)

        assert_equal day1.rows[2].start_end, '11:10 - 11:30'
        assert_equal day1.rows[2].tracks['TrackA'], schedules(:kaigi_day1_time3_track1)
        assert_equal day1.rows[2].tracks['TrackB'], schedules(:kaigi_day1_time3_track2)

        assert_equal day1.rows[3].start_end, '11:45 - 12:30'
        assert_equal day1.rows[3].tracks['TrackA'], schedules(:kaigi_day1_time4_track1)

        day2 = tables['2024-03-19']

        assert_equal day2.rows[0].start_end, '09:00 - 09:30'
        assert_equal day2.rows[0].tracks['TrackA'], schedules(:kaigi_day2_time1_track1)
        assert_equal day2.rows[0].tracks['TrackB'], schedules(:kaigi_day2_time1_track2)
        assert_equal day2.rows[0].tracks['TrackC'], schedules(:kaigi_day2_time1_track3)

        assert_equal day2.rows[1].start_end, '10:00 - 10:30'
        assert_equal day2.rows[1].tracks['TrackA'], schedules(:kaigi_day2_time2_track1)
        assert_equal day2.rows[1].tracks['TrackB'], schedules(:kaigi_day2_time2_track2)

        assert_equal day2.rows[2].start_end, '10:40 - 11:10'
        assert_equal day2.rows[2].tracks['TrackA'], schedules(:kaigi_day2_time3_track1)
        assert_equal day2.rows[2].tracks['TrackB'], schedules(:kaigi_day2_time3_track2)

        assert_equal day2.rows[3].start_end, '13:00 - 14:00'
        assert_equal day2.rows[3].tracks['TrackA'], schedules(:kaigi_day2_time4_track1)
      end

      test '#updated_at returns newest updated at value in row' do
        feature_time = Time.current.change(usec: 0) + 10.seconds

        # this schedule on day1 row 0
        schedules(:kaigi_day1_time1_track1).update!(updated_at: feature_time)

        schedules = events(:kaigi).schedules
        tables = Schedule::Tables.new(schedules)
        day1 = tables['2024-03-18']

        assert_equal feature_time, day1.rows[0].updated_at
      end
    end
  end
end
