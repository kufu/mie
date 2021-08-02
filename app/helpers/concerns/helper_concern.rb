# frozen_string_literal: true

require 'active_support'

module HelperConcern
  extend ActiveSupport::Concern

  DATE_FORMAT = '%Y-%m-%d'
  TIME_FORMAT = '%H:%M:%S'

  private

  def group_schedules_by_date(schedules)
    schedules.group_by do |s|
      s.start_at.strftime(DATE_FORMAT)
    end
  end

  def group_schedules_by_time(schedules)
    schedules.group_by { |s| "#{s.start_at.strftime(TIME_FORMAT)} - #{s.end_at.strftime(TIME_FORMAT)}" }
  end
end
