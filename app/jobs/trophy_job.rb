# frozen_string_literal: true

class TrophyJob < ApplicationJob
  queue_as :default

  def perform(profile)
    Trigger.where('description LIKE ?', 'trophy:%').order(description: :asc).each do |trigger|
      next if trigger.conditions.empty?

      profile_trophy = trigger.perform(profile, 'trophy')
      next unless profile_trophy

      Turbo::StreamsChannel.broadcast_prepend_to(
        profile.user.id,
        :notification,
        target: 'notification',
        partial: 'components/notification',
        locals: { title: I18n.t('trophy.notification', name: profile_trophy.trophy.name) }
      )
    end
  rescue Trigger::TriggerError, StandardError => e
    logger.error(e)
    raise e
  end
end
