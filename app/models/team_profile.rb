# frozen_string_literal: true

class TeamProfile < ApplicationRecord
  belongs_to :team
  belongs_to :profile
end
