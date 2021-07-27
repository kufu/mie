# frozen_string_literal: true

module SchedulesHelper
  DATE_FORMAT = '%Y-%m-%d'
  TIME_FORMAT = '%H:%M:%S'

  def create_table_array(schedules)
    date_grouped = schedules.group_by do |s|
      s.start_at.strftime(DATE_FORMAT)
    end

    date_grouped.map do |k, v|
      tracks = v.map(&:track_name).uniq.sort
      time_grouped = time_grouped_schedules(v)
      arrays = time_grouped.map { |time, s| [time] + track_mapping_schedules(tracks, s) }
      arrays.unshift([nil, tracks].flatten)
      [k, arrays]
    end.to_h
  end

  private

  def time_grouped_schedules(schedules)
    schedules.group_by { |s| "#{s.start_at.strftime(TIME_FORMAT)} - #{s.end_at.strftime(TIME_FORMAT)}" }
  end

  def track_mapping_schedules(tracks, schedules)
    tracks.map { |t| schedules.find { |s| s.track_name == t } }
  end
end
