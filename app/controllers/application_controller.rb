# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout false

  before_action :set_user
  before_action :set_plan
  before_action :set_locale

  around_action :with_time_zone

  rescue_from Exception, with: :server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from PlansController::PlanCrossoverError, with: :bad_request

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
    if @user.plans.blank?
      @user.plans.create!(title: 'My RubyKaigi 2022 set list',
                          description: 'Enjoy my RubyKaigi 2022 set list', public: true)
    end
    @plan = @user.plans.recent.first
  end

  def bad_request(e)
    render status: :bad_request, content_type: 'application/json', body: JSON.dump({ message: e.message })
  end

  def not_found
    render template: 'errors/not_found', status: 404, content_type: 'text/html'
  end

  def server_error
    render template: 'errors/server_error', status: 500, content_type: 'text/html'
  end

  private

  def create_and_set_user
    @user = User.create!
    session[:user_id] = @user.id
    session[:locale] = 'Etc/UTC'
    @user
  end

  def set_locale
    return unless params['locale']
    return unless ActiveSupport::TimeZone.all.map { |z| z.tzinfo.identifier }.include?(params['locale'])

    session[:locale] = params['locale']
    head :ok && return
  end

  def with_time_zone(&)
    if session[:locale]
      Time.use_zone(session[:locale], &)
    else
      yield
    end
  end
end
