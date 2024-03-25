# frozen_string_literal: true

class StaticController < ApplicationController
  include EventRouting

  def index
    redirect_to '/2023'
  end

  def top; end

  def terms_of_service
    render html: I18n.t('terms_of_service.terms_of_service').html_safe
  end
end
