# frozen_string_literal: true

module Events
  extend ActiveSupport::Concern

  included do
    scope :on_event, ->(event) { where(event:) }
  end
end
