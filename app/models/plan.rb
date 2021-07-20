class Plan < ApplicationRecord
  belongs_to :user
  has_many :plan_schedules
  has_many :schedules, through: :plan_schedules
end
