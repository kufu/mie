# frozen_string_literal: true

class TrophiesController < ApplicationController
  before_action :set_trophy, only: %i[show]
  def show; end

  private

  def set_trophy
    @trophy = Trophy.find(params[:id])
  end
end
