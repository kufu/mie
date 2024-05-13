# frozen_string_literal: true

class Friend < ApplicationRecord
  belongs_to :from_profile, class_name: 'Profile', foreign_key: :from
  belongs_to :to_profile, class_name: 'Profile', foreign_key: :to

  validates :from, presence: true
  validates :to, presence: true
end
