# frozen_string_literal: true

class PlanSchedule < ApplicationRecord
  include ActiveModel::Validations
  validates_with Validators::EventEqualityValidator

  belongs_to :plan, touch: true
  belongs_to :schedule

  validates :memo, length: { in: 0..1024 }
end
