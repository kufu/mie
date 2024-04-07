# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  has_many :team_profiles, dependent: :destroy
  has_many :teams, through: :team_profiles

  validates :provider, presence: true
  validates :uid, presence: true
  validates :name, presence: true
  validates :avatar_url, presence: true
end
