# frozen_string_literal: true

require 'active_support'

module HelperConcern
  extend ActiveSupport::Concern

  DATE_FORMAT = '%Y-%m-%d'

  def schedule_track_row(schedule)
    schedule.start_at.strftime(DATE_FORMAT)
  end

  private

  def group_schedules_by_date(schedules)
    schedules.group_by { schedule_track_row(_1) }
  end

  def group_schedules_by_time(schedules)
    schedules.group_by do |s|
      start_at = I18n.l(s.start_at, format: :timetable)
      end_at = I18n.l(s.end_at, format: :timetable)
      zone = s.end_at.strftime('%Z')

      "#{start_at} - #{end_at} (#{zone})"
    end
  end
end
