# frozen_string_literal: true

module ProfilesHelper
  def my_profile?
    @profile == @user&.profile
  end
end
