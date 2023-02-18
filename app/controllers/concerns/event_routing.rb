module EventRouting
  extend ActiveSupport::Concern

  included do
    prepend_before_action :set_event
  end

  def set_event
    @event = Event.find_by!(name: params[:event_name])
  end
end