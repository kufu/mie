# frozen_string_literal: true

module ProfileScheduleMapping
  extend ActiveSupport::Concern

  def set_friends_and_teammates_schedules_mapping
    set_friends_schedules_mapping
    set_teammates_schedules_mapping
  end

  def set_friends_schedules_mapping
    return @friends_schedules_map = {} unless @user&.profile

    @friends_schedules_map = ScheduleProfileMapping.new(@user.profile.friend_profiles, @event)
  end

  def set_teammates_schedules_mapping
    return @teammate_schedules_map = {} unless @user&.current_team

    @teammate_schedules_map = ScheduleProfileMapping.new(@user.profile.current_team.profiles, @event)
  end
end
