# frozen_string_literal: true

class SchedulesController < ApplicationController
  def index
    @schedules = Schedule.all.includes(:speaker).order(:start_at)
  end
end
