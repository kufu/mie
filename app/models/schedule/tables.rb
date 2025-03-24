# frozen_string_literal: true

class Schedule
  class Tables
    DATE_FORMAT = '%Y-%m-%d'

    def initialize(schedules)
      @schedules = schedules
      @map = @schedules.group_by { _1.start_at.strftime(DATE_FORMAT) }.to_h do |k, v|
        [k, Schedule::Table.new(v, k)]
      end
    end

    def days
      @map.keys.sort_by { Time.parse(_1).to_i }
    end

    def [](key)
      @map[key]
    end

    # Schedules::Table is the only one for each events
    def id
      @id ||= @schedules[0].track.event.name
    end

    def tables
      @map.values
    end

    def updated_at
      @updated_at ||= @schedules.map(&:updated_at).max
    end

    def cache_key
      "schedules/#{id}-#{updated_at.to_fs(:usec)}"
    end
  end
end
