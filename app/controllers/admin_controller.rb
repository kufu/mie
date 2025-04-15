# frozen_string_literal: true

class AdminController < ApplicationController
  skip_before_action :set_locale

  before_action :make_sure_user_is_admin

  skip_after_action :check_trophy

  private

  def make_sure_user_is_admin
    return if @user&.admin?

    render template: 'errors/forbidden', status: 401, layout: 'application', content_type: 'text/html'
  end
end
