# frozen_string_literal: true

class Api::ApiController < ApplicationController
  layout false

  rescue_from Exception, with: :server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from PlanCrossoverError, with: :bad_request
  rescue_from NotHasScheduleError, with: :bad_request

  def bad_request(e)
    render status: :bad_request, content_type: 'application/json', body: JSON.dump({ message: e.message })
  end

  def not_found(e)
    render status: :not_found, content_type: 'application/json', body: JSON.dump({message: '["Not Found"]'})
  end

  def server_error(e)
    body = Rails.env.development? ? JSON.dump({ message: e.message }) : nil
    render status: :internal_server_error, content_type: 'application/json', body:
  end
end
