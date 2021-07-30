# frozen_string_literal: true

class PlanDatetimeOverlapValidator < ActiveModel::Validator
  def validate(record)
    time_ranges = record.plan_schedules.map(&:schedule).map do |s|
      { schedule: s, time: ((s.start_at)..(s.end_at)) }
    end

    time_ranges.combination(2).each do |left, right|
      record.errors.add(:schedules, error_message(left[:schedule], right[:schedule])) if check_overlapping(left, right)
    end
  end

  private

  def check_overlapping(left, right)
    same_datetime(left[:time], right[:time]) || partial_cover(left[:time], right[:time])
  end

  def same_datetime(left, right)
    left.first == right.first && left.last == right.last
  end

  def partial_cover(left, right)
    if left.last == right.first || right.last == left.first
      false
    else
      left.cover?(right.first) || left.cover?(right.last)
    end
  end

  def error_message(left, right)
    "#{left.title} and #{right.title} are overlapping time"
  end
end

class Plan < ApplicationRecord
  belongs_to :user
  has_many :plan_schedules
  has_many :schedules, through: :plan_schedules

  validates :title, presence: true, length: { in: 1..100 }
  validates :description, length: { in: 0..1024 }
  validates :public, inclusion: { in: [true, false] }
  validates_with PlanDatetimeOverlapValidator
end
