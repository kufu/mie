# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :set_user
  skip_before_action :set_plan
  skip_before_action :set_locale
  skip_before_action :set_last_path

  def create
    user_info = request.env['omniauth.auth']
    redirect_to session[:last_path]
  end
end
