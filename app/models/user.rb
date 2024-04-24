# frozen_string_literal: true

class User < ApplicationRecord
  has_one :profile
  has_many :plans

  def current_plan
    plans.where(event: Event.order(created_at: :desc).first).order(created_at: :desc).first
  end
end
