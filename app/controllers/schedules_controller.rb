# frozen_string_literal: true

class SchedulesController < ApplicationController
  layout false

  def page; end

  def index
    @schedules = Schedule.all.includes(:speakers).order(:start_at)
    render 'api/schedules/index.json'
  end
end
