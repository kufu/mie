class Track < ApplicationRecord
  belongs_to :event
  has_many :schedules

  validates :name, presence: true
  validates :position, presence: true
end
