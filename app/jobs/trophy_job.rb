# frozen_string_literal: true

class TrophyJob < ApplicationJob
  queue_as :default

  def perform(profile)
    Trigger.where('description LIKE ?', 'trophy:%').order(description: :asc).each do |trigger|
      logger.info("Trigger: #{trigger.description}")
      next if trigger.conditions.empty?

      trigger.perform(profile, 'trophy')
    end
  rescue Trigger::TriggerError, StandardError => e
    logger.error(e)
    raise e
  end
end
