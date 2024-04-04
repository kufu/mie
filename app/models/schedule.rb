# frozen_string_literal: true

class Schedule < ApplicationRecord
  include Events

  has_many :schedule_speakers
  has_many :speakers, through: :schedule_speakers
  has_many :plan_schedules

  belongs_to :event
  belongs_to :track

  enum language: { en: 0, ja: 1, 'en & ja': 2 }

  validates :title, presence: true, length: { in: 1..100 }
  validates :description, length: { in: 0..1024 }
  validates :language, presence: true
end
