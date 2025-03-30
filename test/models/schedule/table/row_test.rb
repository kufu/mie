# frozen_string_literal: true

require 'test_helper'

class Schedule
  class Table
    class RowTest < ActiveSupport::TestCase
      test '#== can compare two rows equality' do
        assert_equal Schedule::Tables.from_event(events(:kaigi)).tables.first.rows.first,
                     Schedule::Tables.from_event(events(:kaigi)).tables.first.rows.first
      end

      test '#== can compare two rows not equality' do
        assert_not_equal Schedule::Tables.from_event(events(:kaigi)).tables.first.rows.first,
                         Schedule::Tables.from_event(events(:kaigi)).tables.first.rows.second
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

      test '#expects with same schedule array, it returns same schedules' do
        schedules = [schedules(:one), schedules(:one_crossover)]
        row = Schedule::Table::Row.new(schedules)
        new_row = row.expect(schedules)

        assert_equal row, new_row
      end

      test '#expects with sub array, it returns only sub arrays schedules' do
        schedules = [schedules(:one), schedules(:one_crossover)]
        row = Schedule::Table::Row.new(schedules)
        new_row = row.expect([schedules(:one)])

        assert_equal 1, new_row.schedules.size
        assert_equal [schedules(:one)], new_row.schedules
      end

      test '#expects ignores schedule that is not contain original array' do
        schedules = [schedules(:one), schedules(:one_crossover)]
        row = Schedule::Table::Row.new(schedules)
        new_row = row.expect([schedules(:one), schedules(:two)])

        assert_equal 1, new_row.schedules.size
        assert_equal [schedules(:one)], new_row.schedules
      end

      test '#expects with empty array, it returns empty schedules' do
        schedules = [schedules(:one), schedules(:one_crossover)]
        row = Schedule::Table::Row.new(schedules)
        new_row = row.expect([])

        assert new_row.schedules.empty?
      end

      test '#expects returns new row object that does not affect the original row' do
        schedules = [schedules(:one), schedules(:one_crossover)]
        row = Schedule::Table::Row.new(schedules)
        new_row = row.expect(schedules)
        new_row.schedules.pop
        new_row.tracks.delete(new_row.tracks.keys.first)

        assert_not_equal row.schedules.size, new_row.schedules.size
        assert_not_equal row.tracks.keys.size, new_row.tracks.keys.size
      end
    end
  end
end
