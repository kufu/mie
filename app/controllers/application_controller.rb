# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_user
  before_action :set_plan
  before_action :set_locale

  around_action :with_time_zone

  def set_user
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      create_and_set_user
    end
  rescue ActiveRecord::RecordNotFound
    create_and_set_user
  end

  def set_plan
    @user.plans.create!(title: 'My plan', description: 'ogehoge') if @user.plans.blank?
    @plan = @user.plans.first
  end

  private

  def create_and_set_user
    @user = User.create!
    session[:user_id] = @user.id
    @user
  end

  def create_default_plan(user)
    user.plans.create!(title: 'My plans')
  end

  def set_locale
    return unless params['locale']
    return unless ActiveSupport::TimeZone.all.map { |z| z.tzinfo.identifier }.include?(params['locale'])

    session[:locale] = params['locale']
    redirect_to request.path
  end

  def with_time_zone(&block)
    if session[:locale]
      Time.use_zone(session[:locale], &block)
    else
      yield
    end
  end
end
