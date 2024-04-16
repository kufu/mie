# frozen_string_literal: true

require 'test_helper'

class ProfileTrophyTest < ActiveSupport::TestCase
  test "Can't create duplicate record" do
    assert_difference -> { ProfileTrophy.count } => 1 do
      ProfileTrophy.create(profile: profiles(:profile_five), trophy: trophies(:common_trophy))
      ProfileTrophy.create(profile: profiles(:profile_five), trophy: trophies(:common_trophy))
    end
  end
end
