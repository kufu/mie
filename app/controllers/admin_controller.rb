# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :make_sure_user_is_admin

  private

  def make_sure_user_is_admin
    return if @user&.admin?

    render template: 'errors/forbidden', status: 401, layout: 'application', content_type: 'text/html'
  end
end
