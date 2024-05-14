# frozen_string_literal: true

class StaticController < ApplicationController
  include EventRouting

  skip_before_action :set_last_path, only: :terms_of_service

  def index
    redirect_to '/2024'
  end

  def top; end

  def terms_of_service
    render html: I18n.t('terms_of_service.terms_of_service').html_safe
  end
end
