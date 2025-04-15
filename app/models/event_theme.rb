# frozen_string_literal: true

class EventTheme < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :event

  validates :main_color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/ }
end
