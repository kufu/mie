# frozen_string_literal: true

class Trophy < ApplicationRecord
  has_many :profile_trophies, dependent: :destroy
  has_many :profiles, through: :profile_trophies

  validates :name, presence: true
  validates :description, presence: true
  validates :icon_url, presence: true
  validates :rarity, presence: true

  enum :rarity, { common: 0, uncommon: 1, rare: 2, mythic_rare: 3 }, default: :common
end
