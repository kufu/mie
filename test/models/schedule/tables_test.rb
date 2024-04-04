# frozen_string_literal: true

require 'test_helper'

class Schedule
  class TablesTest < ActiveSupport::TestCase
    def setup
      schedules = Schedule.where(event: events(:kaigi))
      @tables = Schedule::Tables.new(schedules)
    end

    test 'schedule table can return days of timetables orderd by asc' do
      assert_equal @tables.days, %w[2024-03-18 2024-03-19]
    end

    test '[] method returns Schedule::Table' do
      assert_equal @tables[@tables.days.first].class, Schedule::Table
    end
  end
end
