# frozen_string_literal: true

class ProfileTrophy < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :profile
  belongs_to :trophy

  validates :profile, presence: true, uniqueness: { scope: :trophy }
  validates :trophy, presence: true
end
