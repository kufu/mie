# frozen_string_literal: true

class Api::SchedulesController < Api::ApiController
  def index
    @schedules = Schedule.all.includes(:speakers).order(:start_at)
    render 'api/schedules/index.json'
  end
end
