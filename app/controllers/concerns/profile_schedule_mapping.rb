# frozen_string_literal: true

module ProfileScheduleMapping
  extend ActiveSupport::Concern

  included do
    before_action :set_friends_schedules_mapping
    before_action :set_teammates_schedules_mapping
  end

  def set_friends_schedules_mapping
    return @friends_schedules_map = {}unless @user.profile

    @friends_schedules_map = @user.profile.friend_profiles.to_h do |profile|
      [profile, profile.user.plans.find_by(event: @event)&.plan_schedules&.map(&:schedule_id) || []]
    end
  end

  def set_teammates_schedules_mapping
    return @teammate_schedules_map = {} unless @user.profile

    @teammate_schedules_map = @user.profile.current_team.profiles.to_h do |profile|
      [profile, profile.user.current_plan&.plan_schedules&.map(&:schedule_id) || []]
    end
  end
end
