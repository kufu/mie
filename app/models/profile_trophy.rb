# frozen_string_literal: true

class ProfileTrophy < ApplicationRecord
  belongs_to :profile
  belongs_to :trophy
end
