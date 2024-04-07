# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :team_profiles, dependent: :destroy
  has_many :profiles, through: :team_profiles, dependent: :destroy
end
