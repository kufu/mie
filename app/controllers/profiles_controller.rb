# frozen_string_literal: true

class ProfilesController < ApplicationController
  prepend_before_action :set_event

  def show
    flash.keep if turbo_frame_request?
  end

  private

  def set_event
    @event = Event.order(created_at: :desc).first
    request.path_parameters[:event_name] = @event.name
    @plan = Plan.new
  end
end
