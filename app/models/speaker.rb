# frozen_string_literal: true

class Speaker < ApplicationRecord
  has_many :schedules

  validates :name, presence: true, length: { in: 1..100 }
  validates :handle, length: { in: 0..100 }
  validates :profile, length: { in: 0..1024 }
  validates :thumbnail, presence: true, length: { in: 0..1024 }
end
