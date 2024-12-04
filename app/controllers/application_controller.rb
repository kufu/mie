# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_default_event
  before_action :set_user
  before_action :set_plan
  before_action :set_locale
  before_action :set_last_path
  before_action :breakout_turbo

  around_action :with_time_zone

  after_action :check_trophy

  rescue_from Exception, with: :server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request # TODO: Remove in Rails8

  def set_user
    @user = User.find(session[:user_id]) if session[:user_id]
  end

  def set_plan
    @plan = (@user && @user.plans.where(event: @event).recent&.first) ||
            Plan.new(title: "My RubyKaigi #{@event.name} set list",
                     description: "Enjoy my RubyKaigi #{@event.name} set list",
                     public: true,
                     event: @event)
  end

  def not_found(err = nil)
    if err
      print_error_if_test(err)
      Rails.logger.debug("#{err}\n#{err.backtrace.join("\n")}")
    end

    render template: 'errors/not_found', status: 404, layout: 'application', content_type: 'text/html'
  end

  def bad_request(err = nil)
    Rails.logger.debug("#{err}\n#{err.backtrace.join("\n")}") if err

    render status: :bad_request, body: nil
  end

  def server_error(err)
    print_error_if_test(err)
    Rails.logger.error("#{err}\n#{err.backtrace.join("\n")}")
    render template: 'errors/server_error', status: 500, layout: 'application', content_type: 'text/html'
  end

  private

  def set_default_event
    return if @event

    @event = Event.all.order(created_at: :desc).first
    request.path_parameters[:event_name] = @event.name
  end

  def make_sure_user_logged_in
    return if @user&.profile

    session[:breakout_turbo] = true
    redirect_to profile_path, flash: { error: I18n.t('errors.login_required') }
  end

  def create_and_set_user
    @user = User.create!
    session[:user_id] = @user.id
    @user
  end

  def set_locale
    return unless params.key?('locale')

    locale = if ActiveSupport::TimeZone.all.map do |z|
                  z.tzinfo.identifier
                end.include?(params['locale'])
               params['locale']
             else
               'Etc/UTC'
             end
    session[:locale] = locale
  end

  def set_last_path
    session[:last_path] = request.fullpath
  end

  def with_time_zone(&)
    if session[:locale]
      Time.use_zone(session[:locale], &)
    else
      yield
    end
  end

  def print_error_if_test(err)
    return unless Rails.env.test?

    pp params
    puts err.message
    puts err.backtrace.join("\n")
  end

  def breakout_turbo
    return unless session[:breakout_turbo]

    session[:breakout_turbo] = nil
    @breakout_turbo = true
  end

  def check_trophy
    TrophyJob.perform_later(@user.profile) if @user&.profile
  end
end
