# frozen_string_literal: true

class ProfilesController < ApplicationController
  include EventRouting

  def show
    flash.keep if turbo_frame_request?
  end
end
