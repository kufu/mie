# frozen_string_literal: true

class SchedulesController < ApplicationController
  include EventRouting
  include ScheduleTable

  def index
    @schedules = Schedule.on_event(@event).includes(:speakers, :track).order(:start_at)
    @schedule_table = Schedule::Tables.new(@schedules)
  end

  def dialog
    @schedule = Schedule.find(params[:schedule_id])
  end
end
