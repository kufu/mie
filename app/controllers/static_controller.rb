# frozen_string_literal: true

class StaticController < ApplicationController
  layout false

  def index
    redirect_to '/2022'
  end

  def top; end

  def root2022; end
end
