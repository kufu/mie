# frozen_string_literal: true

class Track < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :event
  has_many :schedules

  validates :name, presence: true
  validates :position, presence: true
end
