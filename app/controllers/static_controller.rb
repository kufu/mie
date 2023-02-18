# frozen_string_literal: true

class StaticController < ApplicationController
  include EventRouting

  def index
    redirect_to '/2021'
  end

  def top; end
end
