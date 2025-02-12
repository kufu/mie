# frozen_string_literal: true

class Trophy < ApplicationRecord
  has_many :profile_trophies, dependent: :destroy
  has_many :profiles, through: :profile_trophies
  has_one :event_trophy
  has_one :event, through: :event_trophy

  validates :name, presence: true
  validates :description, presence: true
  validates :icon_url, presence: true
  validates :rarity, presence: true
  validates :special, inclusion: { in: [true, false] }

  enum :rarity, { common: 0, uncommon: 1, rare: 2, mythic_rare: 3 }, default: :common

  scope :global_trophies, -> { all.left_outer_joins(:event_trophy).where(event_trophies: { event: nil }) }
end
