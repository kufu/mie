# frozen_string_literal: true

class MeController < ApplicationController
  def show
    render 'api/me/show.json'
  end
end
