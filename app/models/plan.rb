# frozen_string_literal: true

class Plan < ApplicationRecord
  belongs_to :user
  has_many :plan_schedules
  has_many :schedules, through: :plan_schedules

  validates :title, presence: true, length: { in: 1..100 }
  validates :description, length: { in: 0..1024 }
  validates :public, inclusion: { in: [true, false] }
end
