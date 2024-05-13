# frozen_string_literal: true

require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  def setup
    @user = User.create!
    @profile = Profile.create!(user: @user, name: 'test profile', provider: 'test', uid: 'test', avatar_url: 'https://example.com')
  end

  test '#current_team returns team that profile belongs to as member or admin' do
    teams(:alpha).team_profiles.create(profile: @profile, role: :member)
    teams(:bravo).team_profiles.create(profile: @profile, role: :invitation)

    assert_equal teams(:alpha), @profile.current_team
  end

  test '#belongs_to_any_team? returns true when profile has team_profile record with member role' do
    teams(:alpha).team_profiles.create!(profile: @profile, role: :member)
    assert @profile.belongs_to_any_team?
  end

  test '#belongs_to_any_team? returns true when profile has team_profile record with admin role' do
    teams(:alpha).team_profiles.create!(profile: @profile, role: :admin)
    assert @profile.belongs_to_any_team?
  end

  test '#belongs_to_any_team? returns false when profile has team_profile record with invitation role' do
    teams(:alpha).team_profiles.create!(profile: @profile, role: :invitation)
    assert_not @profile.belongs_to_any_team?
  end

  test '#belongs_to_team? returns true when profile belongs to given team with member' do
    teams(:alpha).team_profiles.create!(profile: @profile, role: :member)
    assert @profile.belongs_to_team?(teams(:alpha))
  end

  test '#belongs_to_team? returns true when profile belongs to given team with admin' do
    teams(:alpha).team_profiles.create!(profile: @profile, role: :admin)
    assert @profile.belongs_to_team?(teams(:alpha))
  end

  test '#belongs_to_team? returns false when profile belongs to given team with invitation' do
    teams(:alpha).team_profiles.create!(profile: @profile, role: :invitation)
    assert_not @profile.belongs_to_team?(teams(:alpha))
  end

  test '#belongs_to_team? returns false when profile is not belongs to given team' do
    teams(:alpha).team_profiles.create!(profile: @profile, role: :admin)
    assert_not @profile.belongs_to_team?(teams(:bravo))
  end

  test '#invitations? returns true when profile has team_profile record with invitation role' do
    teams(:alpha).team_profiles.create!(profile: @profile, role: :invitation)
    assert @profile.invitations?
  end

  test '#invitations? returns true when profile has team_profile record with invitation role and belongs to other' do
    teams(:alpha).team_profiles.create!(profile: @profile, role: :invitation)
    teams(:bravo).team_profiles.create!(profile: @profile, role: :admin)
    assert @profile.invitations?
  end

  test '#friend_profiles retuns friends profile models' do
    Friend.create!(from: @profile.id, to: profiles(:profile_one).id)
    Friend.create!(from: @profile.id, to: profiles(:profile_two).id)

    assert_equal [profiles(:profile_one), profiles(:profile_two)], @profile.friend_profiles.to_a
  end
end
