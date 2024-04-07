# frozen_string_literal: true

require 'test_helper'

class TeamProfileTest < ActiveSupport::TestCase
  test "Can't create duplicate entry (validator)" do
    TeamProfile.create!(team: teams(:bravo), profile: profiles(:profile_one))
    team_profile = TeamProfile.new(team: teams(:bravo), profile: profiles(:profile_one))

    assert_not team_profile.valid?
  end

  test "Can't create duplicate entry (database)" do
    TeamProfile.create!(team: teams(:bravo), profile: profiles(:profile_one))
    assert_raise(ActiveRecord::RecordInvalid) do
      TeamProfile.create!(team: teams(:bravo), profile: profiles(:profile_one))
    end
  end

  test 'default role is invitation' do
    team_profile = TeamProfile.new(team: teams(:bravo), profile: profiles(:profile_one))
    assert_equal 'invitation', team_profile.role
  end
end
