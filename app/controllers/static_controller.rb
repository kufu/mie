# frozen_string_literal: true

class StaticController < ApplicationController
  def index
    redirect_to '/2023'
  end

  def top; end
end
