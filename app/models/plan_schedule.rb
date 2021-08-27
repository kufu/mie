# frozen_string_literal: true

class PlanSchedule < ApplicationRecord
  belongs_to :plan
  belongs_to :schedule

  validates :memo, length: { in: 0..1024 }
end
