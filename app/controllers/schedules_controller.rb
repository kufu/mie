# frozen_string_literal: true

class SchedulesController < ApplicationController
  include EventRouting
  include ScheduleTable

  def index
    @schedules = @event.schedules.includes(:speakers, :track).order(:start_at)
    @schedule_table = Schedule::Tables.new(@schedules)

    return unless @user&.profile

    @friends_schedules_map = @user.profile.friend_profiles.to_h do |profile|
      [profile.id, profile.user.plans.find_by(event: @event)&.plan_schedules&.map(&:schedule_id) || []]
    end
  end

  def dialog
    @schedule = Schedule.find(params[:schedule_id])
  end
end
