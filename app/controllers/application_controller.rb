# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_user

  def set_user
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      create_and_set_user
    end
  rescue ActiveRecord::RecordNotFound
    create_and_set_user
  end

  private

  def create_and_set_user
    @user = User.create!
    session[:user_id] = @user.id
    @user
  end
end
