# frozen_string_literal: true

class SchedulesController < ApplicationController
  include EventRouting

  def index
    @schedule_table = Schedule::Tables.from_event(@event)

    return unless @user&.profile

    @friends_schedules_map = @user.profile.friend_profiles.to_h do |profile|
      [profile.id, profile.user.plans.find_by(event: @event)&.plan_schedules&.map(&:schedule_id) || []]
    end
  end

  def dialog
    @schedule = Schedule.find(params[:schedule_id])
  end
end
