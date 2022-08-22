# frozen_string_literal: true

class MeController < ApiController
  def show
    render 'api/me/show.json'
  end
end
