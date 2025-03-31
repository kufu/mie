# frozen_string_literal: true

class SchedulesController < ApplicationController
  include EventRouting
  include ProfileScheduleMapping

  def index
    @schedule_table = Schedule::Tables.from_event(@event)
    set_friends_and_teammates_schedules_mapping
  end

  def dialog
    @schedule = Schedule.find(params[:schedule_id])
  end
end
