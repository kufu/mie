# frozen_string_literal: true

class Event < ApplicationRecord
  has_one :event_theme, dependent: :destroy
  has_many :tracks

  validates :name, presence: true, length: { in: 1..32 }
  validates :event_theme, presence: true
end
