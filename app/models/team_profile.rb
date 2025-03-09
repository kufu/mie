# frozen_string_literal: true

class TeamProfile < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :team
  belongs_to :profile

  before_validation :check_no_one_admin

  validate :not_a_member_of_others

  enum :role, { admin: 0, member: 1, invitation: 2 }, default: :invitation

  validates :team, uniqueness: { scope: :profile, message: 'Duplicate entry' }

  private

  def check_no_one_admin
    return unless !admin? && team.team_profiles.where.not(profile:).where(role: :admin).count < 1

    errors.add :role, I18n.t('errors.no_admins')
  end

  def not_a_member_of_others
    return unless new_record? && profile.team_profiles.where(role: %w[admin member]).count >= 1

    errors.add(:only_one_team, I18n.t('errors.only_one_team'))
  end
end
