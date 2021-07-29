# frozen_string_literal: true

require 'active_support'

module HelperConcern
  extend ActiveSupport::Concern

  DATE_FORMAT = '%Y-%m-%d'

  def group_schedules_by_date(schedules)
    schedules.group_by do |s|
      s.start_at.strftime(DATE_FORMAT)
    end
  end
end
