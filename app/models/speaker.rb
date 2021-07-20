# frozen_string_literal: true

class Speaker < ApplicationRecord
  has_many :schedules

  enum language: { en: 0, ja: 1 }
end
