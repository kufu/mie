# frozen_string_literal: true

class ProfilesController < ApplicationController
  def show
    flash.keep if turbo_frame_request?
  end
end
