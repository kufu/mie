# frozen_string_literal: true

class SchedulesController < ApplicationController
  include EventRouting
  include ScheduleTable

  def index
    @schedules = Schedule.on_event(@event).includes(:speakers).order(:start_at)
    @table_array = create_table_array(@schedules)
    @schedule_table = schedule_table(@table_array)
  end

  def dialog
    @schedule = Schedule.find(params[:schedule_id])
  end
end
