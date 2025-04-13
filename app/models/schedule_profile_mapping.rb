# frozen_string_literal: true

class ScheduleProfileMapping
  attr_reader :mapping

  delegate :map, to: :mapping

  def initialize(profiles, event)
    @profiles = profiles
    @event = event
    @mapping = {}

    generate_mapping
  end

  def id
    @id ||= Digest::SHA1.hexdigest(@profiles.map(&:id).sort.join)
  end

  def fetch(profile)
    @mapping[profile]
  end

  alias [] fetch

  def updated_at
    @last_updated_at || Time.at(0)
  end

  def cache_key
    "schedule_profile_mapping/#{id}-#{updated_at.to_fs(:usec)}"
  end

  private

  def generate_mapping
    users = User.includes(:profile, plans: { plan_schedules: [:schedule] }).where(id: @profiles.map(&:user).map(&:id))
    users.each do |user|
      plan = user.plans.find_by(event: @event)
      @mapping[user.profile] = if plan
                                 register_updated_at(plan.updated_at)
                                 plan.plan_schedules.map(&:schedule_id)
                               else
                                 []
                               end
    end
  end

  def register_updated_at(time)
    return @last_updated_at = time unless @last_updated_at

    @last_updated_at = time if @last_updated_at < time
  end
end
