# frozen_string_literal: true

require 'test_helper'

class Schedule
  class TableTest < ActiveSupport::TestCase
    def setup
      schedules = events(:kaigi).schedules
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

    test '#track_list returns track names sorted by Track#position' do
      event = Event.build(name: 'track_sort_test')
      event.build_event_theme(
        main_color: '#0B374D',
        sub_color: '#EBE0CE',
        accent_color: '#D7D165',
        text_color: '#23221F',
        overview: 'hoge',
        site_label: 'foo',
        site_url: 'https://example.com'
      )
      event.save!
      track_a = event.tracks.create!(name: 'A', position: 2)
      track_b = event.tracks.create!(name: 'B', position: 1)
      speaker = event.speakers.create!(name: 'kinoppyd', handle: 'ppyd', profile: 'wooo', thumbnail: 'https://example.com')

      schedule_a = track_a.schedules.create!(title: 'test1', speakers: [speaker], start_at: '2024-04-06 01:50',
                                             end_at: '2024-04-06 01:55')
      schedule_b = track_b.schedules.create!(title: 'test2', speakers: [speaker], start_at: '2024-04-06 01:50',
                                             end_at: '2024-04-06 01:55')

      table = Schedule::Table.new([schedule_a, schedule_b])

      assert_equal %w[B A], table.track_list

      track_a.update!(position: 1)
      track_b.update!(position: 2)

      table = Schedule::Table.new([schedule_a, schedule_b])

      assert_equal %w[A B], table.track_list
    end

    test '#updated_at returns newest updated at value in table' do
      feature_time = Time.current.change(usec: 0) + 10.seconds

      # this schedule on day1 row 0
      schedules(:kaigi_day1_time1_track1).update!(updated_at: feature_time)

      schedules = events(:kaigi).schedules
      tables = Schedule::Tables.new(schedules)
      @table = tables[tables.days.first]

      assert_equal feature_time, @table.updated_at
    end
  end
end
