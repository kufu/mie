# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :team_profiles, dependent: :destroy
  has_many :profiles, through: :team_profiles, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { in: 1..64 }

  def admin?(user)
    !!user.profile.team_profiles.find_by(team: self)&.admin?
  end
end
