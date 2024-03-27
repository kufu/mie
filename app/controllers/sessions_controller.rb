# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :set_plan
  skip_before_action :set_locale
  skip_before_action :set_last_path

  def create
    create_and_set_user unless @user

    user_info = request.env['omniauth.auth']
    @user.create_profile(
      provider: user_info['provider'],
      uid: user_info['uid'],
      name: user_info['info']['name'],
      email: user_info['info']['email'],
      avatar_url: user_info['info']['image']
    )
    redirect_to session[:last_path]
  end
end
