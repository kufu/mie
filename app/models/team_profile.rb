# frozen_string_literal: true

class TeamProfile < ApplicationRecord
  belongs_to :team
  belongs_to :profile

  enum :role, { admin: 0, memher: 1, invitation: 2 }, default: :invitation

  validates :team, uniqueness: { scope: :profile, message: 'Duplicate entry' }
end
