# frozen_string_literal: true

require 'test_helper'

class Schedule
  class TableTest < ActiveSupport::TestCase
    def setup
      schedules = Schedule.where(event: events(:kaigi))
      tables = Schedule::Tables.new(schedules)
      @table = tables[tables.days.first]
    end

    test '#track_list returns track names array' do
      assert_equal @table.track_list, %w[TrackA TrackB TrackC]
    end

    test '#rows retuns arrays of Schedule::Table::Row' do
      assert @table.rows.all? { _1.instance_of?(Schedule::Table::Row) }
    end

    test '#rows returns array sorted by track start time' do
      assert_equal @table.rows.map { _1.tracks['TrackA'] }, @table.rows.map { _1.tracks['TrackA'] }.sort_by(&:start_at)
    end
  end
end
