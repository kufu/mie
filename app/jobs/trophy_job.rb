# frozen_string_literal: true

class TrophyJob < ApplicationJob
  queue_as :default

  def perform(profile)
    Trigger.where('description LIKE ?', 'trophy:%').each do |trigger|
      trigger.perform(profile, 'trophy')
    end
  end
end
