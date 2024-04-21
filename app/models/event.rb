# frozen_string_literal: true

class Event < ApplicationRecord
  has_one :event_theme, dependent: :destroy
  has_many :tracks
  has_many :speakers
  has_many :event_trophies
  has_many :trophies, through: :event_trophies


  validates :name, presence: true, length: { in: 1..32 }
  validates :event_theme, presence: true

  def schedules
    Schedule.where(track: tracks)
  end
end
