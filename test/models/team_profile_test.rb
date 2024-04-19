# frozen_string_literal: true

require 'test_helper'

class TeamProfileTest < ActiveSupport::TestCase
  def setup
    @user = User.create!
    @profile = Profile.create!(user: @user, name: 'test profile', provider: 'test', uid: 'test', avatar_url: 'https://example.com')
  end

  test "Can't create duplicate entry (validator)" do
    TeamProfile.create!(team: teams(:bravo), profile: @profile, role: :admin)
    team_profile = TeamProfile.new(team: teams(:bravo), profile: @profile, role: :admin)

    assert_not team_profile.valid?
  end

  test "Can't create duplicate entry (database)" do
    TeamProfile.create!(team: teams(:bravo), profile: @profile, role: :admin)
    assert_raise(ActiveRecord::RecordNotUnique) do
      TeamProfile.build(team: teams(:bravo), profile: @profile, role: :admin).save(validate: false)
    end
  end

  test 'default role is invitation' do
    team_profile = TeamProfile.new(team: teams(:bravo), profile: profiles(:profile_one))
    assert_equal 'invitation', team_profile.role
  end
end
