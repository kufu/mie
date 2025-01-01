# frozen_string_literal: true

require 'test_helper'

class Schedule
  class TablesTest < ActiveSupport::TestCase
    def setup
      schedules = events(:kaigi).schedules
      @tables = Schedule::Tables.new(schedules)
    end

    test 'schedule table can return days of timetables orderd by asc' do
      assert_equal @tables.days, %w[2024-03-18 2024-03-19]
    end

    test '[] method returns Schedule::Table' do
      assert_equal @tables[@tables.days.first].class, Schedule::Table
    end

    test '#updated_at returns newest updated at value in table' do
      feature_time = Time.current.change(usec: 0) + 10.seconds

      # this schedule on day1 row 0
      schedules(:kaigi_day1_time1_track1).update!(updated_at: feature_time)

      schedules = events(:kaigi).schedules
      tables = Schedule::Tables.new(schedules)

      assert_equal feature_time, tables.updated_at
    end

    test '#id returns schedules event name' do
      assert_equal events(:kaigi).name, @tables.id
    end

    test '#cache_key returns cache key with cache version string' do
      assert_match(%r{schedules/#{events(:kaigi).name}-\d{20}}, @tables.cache_key)
    end

    test 'when schedule record updated, #cache_key version string changes' do
      old_key = @tables.cache_key

      feature_time = Time.current.change(usec: 0) + 10.seconds

      # this schedule on day1 row 0
      schedules(:kaigi_day1_time1_track1).update!(updated_at: feature_time)

      schedules = events(:kaigi).schedules
      # rebuild
      tables = Schedule::Tables.new(schedules)

      refute_equal tables.cache_key, old_key
    end
  end
end
