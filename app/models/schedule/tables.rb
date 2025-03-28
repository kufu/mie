# frozen_string_literal: true

class Schedule
  class Tables
    DATE_FORMAT = '%Y-%m-%d'

    def self.from_event(event)
      Schedule::Tables.new(event.schedules.includes(:speakers, :track).order(:start_at))
    end

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

    def expect(schedules)
      dup.tap do |obj|
        obj.instance_variable_set(:@schedules, schedules)
        obj.instance_variable_set(:@map, @map.transform_values { |v| v.expect(schedules) })
      end
    end

    def updated_at
      @updated_at ||= @schedules.map(&:updated_at).max
    end

    def cache_key
      "schedules/#{id}-#{updated_at.to_fs(:usec)}"
    end

    def ==(other)
      return false unless days == other.days

      days.all? do |key|
        @map[key] == other[key]
      end
    end
  end
end
