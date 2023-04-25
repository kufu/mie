# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_user
  before_action :set_plan
  before_action :set_locale

  around_action :with_time_zone

  rescue_from Exception, with: :server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found

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
    if @user.plans.where(event: @event).blank?
      @user.plans.create!(title: "My RubyKaigi #{@event.name} set list",
                          description: "Enjoy my RubyKaigi #{@event.name} set list",
                          public: true,
                          event: @event)
    end
    @plan = @user.plans.where(event: @event).recent.first
  end

  def not_found(err)
    Rails.logger.debug("#{err}\n#{err.backtrace.join("\n")}")
    render template: 'errors/not_found', status: 404, layout: 'application', content_type: 'text/html'
  end

  def server_error(err)
    Rails.logger.error("#{err}\n#{err.backtrace.join("\n")}")
    render template: 'errors/server_error', status: 500, layout: 'application', content_type: 'text/html'
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
    redirect_to request.path
  end

  def with_time_zone(&)
    if session[:locale]
      Time.use_zone(session[:locale], &)
    else
      yield
    end
  end
end
