# frozen_string_literal: true

class SchedulesController < ApplicationController
  include EventRouting

  def index
    @schedules = Schedule.all.includes(:speakers).order(:start_at)
  end
end
