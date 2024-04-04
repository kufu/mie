# frozen_string_literal: true

class Schedule
  class Table
    class Row
      attr_reader :start_end, :timezone, :schedules, :tracks, :sort_key

      def initialize(schedules)
        start_at = I18n.l(schedules[0].start_at, format: :timetable)
        end_at = I18n.l(schedules[0].end_at, format: :timetable)

        @start_end = "#{start_at} - #{end_at}"
        @timezone = schedules[0].end_at.strftime('%Z')
        @schedules = schedules
        @tracks = schedules.map { [_1.track_name, _1] }.to_h
        @sort_key = schedules[0].start_at
      end
    end
  end
end
