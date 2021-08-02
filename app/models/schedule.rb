# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :speaker
  has_many :plan_schedules

  enum language: { en: 0, ja: 1 }

  validates :title, presence: true, length: { in: 1..100 }
  validates :description, length: { in: 0..1024 }
  validates :track_name, presence: true, length: { in: 1..32 }
  validates :language, presence: true
end
