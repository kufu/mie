# frozen_string_literal: true

class Speaker < ApplicationRecord
  has_many :schedules
end
