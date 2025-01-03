# frozen_string_literal: true

class Schedule
  class Table
    class Row
      attr_reader :start_end, :timezone, :schedules, :tracks, :sort_key

      def initialize(schedules)
        @start_at = I18n.l(schedules[0].start_at, format: :timetable)
        @end_at = I18n.l(schedules[0].end_at, format: :timetable)

        @start_end = "#{@start_at} - #{@end_at}"
        @timezone = schedules[0].end_at.strftime('%Z')
        @schedules = schedules
        @tracks = schedules.to_h { [_1.track.name, _1] }
        @sort_key = schedules[0].start_at
      end

      def turbo_stream_id
        date = schedules[0].start_at.strftime('%Y%m%d')
        [date, @start_at.sub(':', '-'), @end_at.sub(':', '-')].join('-')
      end

      def updated_at
        @updated_at ||= schedules.map(&:updated_at).max
      end
    end
  end
end
