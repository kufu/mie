# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :set_plan
  skip_before_action :set_locale

  def create
    user_info = request.env['omniauth.auth']
    profile = Profile.find_by(uid: user_info['uid'])

    if profile
      session[:user_id] = profile.user.id
    else
      create_and_set_user unless @user
      @user.create_profile(
        provider: user_info['provider'],
        uid: user_info['uid'],
        name: user_info['extra']['raw_info']['login'],
        avatar_url: user_info['info']['image']
      )
    end

    last_path = session.delete(:last_path)
    redirect_to last_path || root_path
  end

  def delete
    session[:user_id] = nil
    session[:breakout_turbo] = true

    redirect_to root_path
  end
end
