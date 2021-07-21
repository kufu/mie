# frozen_string_literal: true

class SchedulesController < ApplicationController
  def index
    @schedules = Schedule.all
  end
end
