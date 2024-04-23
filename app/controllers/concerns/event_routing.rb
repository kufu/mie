# frozen_string_literal: true

module EventRouting
  extend ActiveSupport::Concern

  included do
    prepend_before_action :set_event
  end

  def set_event
    @event = Event.find_by!(name: params[:event_name])
  rescue StandardError => e
    set_default_event
    set_plan
    raise e
  end
end
