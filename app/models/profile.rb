# frozen_string_literal: true

class Profile < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :user
  has_many :team_profiles, dependent: :destroy
  has_many :teams, through: :team_profiles
  has_many :profile_trophies, dependent: :destroy
  has_many :trophies, through: :profile_trophies
  has_many :friends, foreign_key: :from
  has_many :friend_profiles, through: :friends, source: :to_profile

  validates :provider, presence: true
  validates :uid, presence: true
  validates :name, presence: true
  validates :avatar_url, presence: true
  validates :introduce, length: { maximum: 256 }

  def current_team
    team_profiles.find_by(role: %i[admin member])&.team
  end

  def belongs_to_any_team?
    team_profiles.where(role: %i[admin member]).exists?
  end

  def belongs_to_team?(team)
    team_profiles.where(team:, role: %i[admin member]).exists?
  end

  def invitations?
    team_profiles.where(role: :invitation).exists?
  end

  def teams_invited
    team_profiles.where(role: :invitation).map(&:team)
  end
end
