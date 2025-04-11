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

  def update
    if @user.profile.update(profile_params)
      @profile = @user.profile
      render 'show', status: :ok
    else
      render 'dialog', status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:introduce)
  end
end
