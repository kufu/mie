# frozen_string_literal: true

class Api::MeController < Api::ApiController
  def show
    render 'api/me/show.json'
  end
end
