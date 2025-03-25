# frozen_string_literal: true

class Schedule
  class Table
    attr_reader :track_list, :rows, :day

    def initialize(schedules, day = nil)
      @day = day
      @track_list = schedules.map(&:track).uniq.sort_by(&:position).map(&:name)

      grouped_schedules = schedules.group_by do |s|
        start_at = I18n.l(s.start_at, format: :timetable)
        end_at = I18n.l(s.end_at, format: :timetable)
        zone = s.end_at.strftime('%Z')

        "#{start_at} - #{end_at} (#{zone})"
      end

      @rows = grouped_schedules.map { |_, v| Schedule::Table::Row.new(v) }.sort_by(&:sort_key)
    end

    def ==(other)
      track_list == other.track_list && rows == other.rows && day == other.day
    end

    def updated_at
      @updated_at ||= rows.map(&:updated_at).max
    end
  end
end
