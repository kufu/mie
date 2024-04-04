class Track < ApplicationRecord
  belongs_to :event

  validates :name, presence: true
  validates :position, presence: true
end
