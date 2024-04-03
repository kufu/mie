# frozen_string_literal: true

class Schedule
  class Table
    attr_reader :track_list, :rows

    def initialize(schedules)
      @track_list = schedules.map(&:track_name).sort.uniq

      grouped_schedules = schedules.group_by do |s|
        start_at = I18n.l(s.start_at, format: :timetable)
        end_at = I18n.l(s.end_at, format: :timetable)
        zone = s.end_at.strftime('%Z')

        "#{start_at} - #{end_at} (#{zone})"
      end

      @rows = grouped_schedules.map { |_, v| Schedule::Table::Row.new(v) }.sort_by(&:sort_key)
    end
  end
end
