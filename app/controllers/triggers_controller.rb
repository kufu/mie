# frozen_string_literal: true

class TriggersController < ApplicationController
  prepend_before_action :set_default_event
  before_action :make_sure_user_logged_in

  def show
    begin
      trigger = Trigger.find(params[:id])
      trigger.perform(@user.profile, params[:key])
    rescue StandardError => _e
      flash[:error] = I18n.t('trigger.error')
    end

    redirect_to profile_path
  end
end
