# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validates :avatar_url, presence: true
end
