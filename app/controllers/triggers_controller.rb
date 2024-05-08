# frozen_string_literal: true

class TriggersController < ApplicationController
  prepend_before_action :set_default_event
  before_action :make_sure_user_logged_in

  def show
    trigger = Trigger.find(params[:id])
    trigger.perform(@user.profile, params[:key])

    redirect_to profile_path
  end
end
