# frozen_string_literal: true

require 'bcrypt'

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
    I18n.t('errors.time_overlap_error', left: left.title, right: right.title)
  end
end

class Plan < ApplicationRecord
  include BCrypt

  belongs_to :user
  has_many :plan_schedules
  has_many :schedules, through: :plan_schedules

  validates :title, presence: true, length: { in: 1..100 }
  validates :description, length: { in: 0..1024 }
  validates :public, inclusion: { in: [true, false] }
  validates_with PlanDatetimeOverlapValidator

  scope :recent, lambda {
    order(updated_at: :desc)
  }

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
