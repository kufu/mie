# frozen_string_literal: true

module ProfilesHelper
  def my_profile?
    @profile == @user&.profile
  end

  def profile_introduce_max_length
    Profile.validators_on(:introduce).detect do |v|
      v.is_a?(ActiveModel::Validations::LengthValidator)
    end.options[:maximum]
  end
end
