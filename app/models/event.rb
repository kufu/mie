# frozen_string_literal: true

class Event < ApplicationRecord
  validates :name, presence: true, length: { in: 1..32 }
end
