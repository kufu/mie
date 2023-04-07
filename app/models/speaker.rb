# frozen_string_literal: true

class Speaker < ApplicationRecord
  include Events

  has_many :schedule_speakers
  has_many :schedules, through: :schedule_speakers

  belongs_to :event

  validates :name, presence: true, length: { in: 1..100 }
  validates :handle, length: { in: 0..100 }
  validates :profile, length: { in: 0..1024 }
  validates :thumbnail, presence: true, length: { in: 0..1024 }
end
