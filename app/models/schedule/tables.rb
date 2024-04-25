# frozen_string_literal: true

class Schedule
  class Tables
    DATE_FORMAT = '%Y-%m-%d'

    def initialize(schedules)
      @schedules = schedules
      @map = @schedules.group_by { _1.start_at.strftime(DATE_FORMAT) }.transform_values do |v|
        Schedule::Table.new(v)
      end
    end

    def days
      @map.keys.sort_by { Time.parse(_1).to_i }
    end

    def [](key)
      @map[key]
    end
  end
end
