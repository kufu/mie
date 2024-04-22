# frozen_string_literal: true

class User < ApplicationRecord
  has_one :profile
  has_many :plans
end
