# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :speaker
  has_many :plan_schedules

  enum language: { en: 0, ja: 1 }
end
