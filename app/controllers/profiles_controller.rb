# frozen_string_literal: true

class ProfilesController < ApplicationController
  def show
    flash.keep if turbo_frame_request?

    @profile = if params[:id]
                 Profile.find_by!(name: params[:id])
               else
                 @user&.profile
               end
  end
end
