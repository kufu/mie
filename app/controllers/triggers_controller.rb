# frozen_string_literal: true

class TriggersController < ApplicationController
  prepend_before_action :set_default_event
  before_action :make_sure_user_has_profile

  def show
    trigger = Trigger.find(params[:id])
    trigger.perform(@user.profile, params[:key])

    redirect_to event_profile_path
  end

  private

  def make_sure_user_has_profile
    return if @user&.profile

    redirect_to event_profile_path, flash: { error: I18n.t('errors.login_required') }
  end

  def set_default_event
    @event = Event.all.order(created_at: :desc).first
    request.path_parameters[:event_name] = @event.name
  end
end
