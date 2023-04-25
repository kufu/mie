# frozen_string_literal: true

class EventTheme < ApplicationRecord
  belongs_to :event

  validates :main_color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/ }
  validates :sub_color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/ }
  validates :accent_color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/ }
  validates :text_color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/ }
end
