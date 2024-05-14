# frozen_string_literal: true

class Trigger < ApplicationRecord
  class TriggerError < StandardError; end
  class KeyNotMatchError < TriggerError; end
  class NoLeftError < TriggerError; end
  class ExpiresError < TriggerError; end

  validates :description, presence: true
  validates :key, presence: true
  validates :action, presence: true
  validates :amount, presence: true

  validate :check_action_is_json_string

  def perform(target, given_key = '')
    return unless Conditions.new(conditions, target).satisfy?

    check_key(given_key)
    check_amount
    check_expires

    transaction do
      action_as_array.each do |act|
        Action.new(act).perform(target)
      end

      self.amount -= 1
      save!
    end
  end

  def refresh_key
    self.key = SecureRandom.base64(32)
  end

  private

  def check_key(given_key)
    return if key == given_key

    raise KeyNotMatchError, 'key is not match'
  end

  def check_amount
    return if amount >= 1

    raise NoLeftError, 'Sold out'
  end

  def check_expires
    return if expires_at.blank? || Time.zone.now < expires_at

    raise ExpiresError, 'This trigger is expired'
  end

  def action_as_array
    case action
    when Hash
      [action]
    else
      action
    end
  end

  def check_action_is_json_string
    return if action.is_a?(Hash) || action.is_a?(Array)

    self.action = JSON.parse(action)
  rescue JSON::ParserError
    errors.add(:action, 'Invalid JSON string')
  end
end
