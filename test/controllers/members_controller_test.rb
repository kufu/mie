# frozen_string_literal: true

require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  def setup
    omniauth_callback_uid(1234) # profile_one
    get '/auth/github/callback'
  end

  test 'invite new member with role :invitation' do
    user = User.create
    profile = user.create_profile(provider: 'test', uid: '112233', name: 'tester', avatar_url: 'https://example.com')

    assert_difference -> { TeamProfile.count } => 1 do
      post team_members_path(team_id: teams(:alpha)), params: { profile_name: profile.name }
    end

    assert_response :created

    assert_equal 'invitation', TeamProfile.find_by(profile:).role
  end

  test 'invite faild if username is note exists' do
    assert_no_difference -> { TeamProfile.count } do
      post team_members_path(team_id: teams(:alpha)), params: { profile_name: 'noexistencemember' }
    end

    assert_response :unprocessable_entity
  end

  test 'invite faild if target is already belongs to other team' do
    omniauth_callback_uid('17181920') # profile_five
    get '/auth/github/callback'

    assert_no_difference -> { TeamProfile.count } do
      post team_members_path(team_id: teams(:bravo)), params: { profile_name: profiles(:profile_two).name }
    end

    assert_response :unprocessable_entity
  end

  test 'admin can change member to admin' do
    assert_difference -> { TeamProfile.admin.count } => 1, -> { TeamProfile.member.count } => -1 do
      patch team_member_path(profiles(:profile_two), team_id: teams(:alpha)), params: { role: :admin }
    end

    assert_response :ok
  end

  test 'admin can change admin to member' do
    TeamProfile.find_by(profile: profiles(:profile_three)).update!(role: :admin)

    assert_difference -> { TeamProfile.admin.count } => -1, -> { TeamProfile.member.count } => 1 do
      patch team_member_path(profiles(:profile_three), team_id: teams(:alpha)), params: { role: :member }
    end

    assert_response :ok
  end

  test 'admin can not change invitation to member' do
    assert_no_difference -> { TeamProfile.admin.count }, -> { TeamProfile.member.count } do
      patch team_member_path(profiles(:profile_three), team_id: teams(:alpha)), params: { role: :member }
    end

    assert_response :unprocessable_entity
  end

  test 'member can not change member to admin' do
    omniauth_callback_uid(5678) # profile_two, member role
    get '/auth/github/callback'

    assert_no_difference -> { TeamProfile.admin.count }, -> { TeamProfile.member.count } do
      patch team_member_path(profiles(:profile_two), team_id: teams(:alpha)), params: { role: :admin }
    end

    assert_response :forbidden
  end

  test 'member can not change admin to member' do
    omniauth_callback_uid(5678) # profile_two, member role
    get '/auth/github/callback'

    assert_no_difference -> { TeamProfile.admin.count }, -> { TeamProfile.member.count } do
      patch team_member_path(profiles(:profile_one), team_id: teams(:alpha)), params: { role: :member }
    end

    assert_response :forbidden
  end

  test 'member can not change invitation to member' do
    omniauth_callback_uid(5678) # profile_two, member role
    get '/auth/github/callback'

    assert_no_difference -> { TeamProfile.admin.count }, -> { TeamProfile.member.count } do
      patch team_member_path(profiles(:profile_three), team_id: teams(:alpha)), params: { role: :member }
    end

    assert_response :forbidden
  end

  test 'invitation can not change member to admin' do
    omniauth_callback_uid('9101112') # profile_three, member invitation
    get '/auth/github/callback'

    assert_no_difference -> { TeamProfile.admin.count }, -> { TeamProfile.member.count } do
      patch team_member_path(profiles(:profile_two), team_id: teams(:alpha)), params: { role: :admin }
    end

    assert_response :forbidden
  end

  test 'invitations can not change admin to member' do
    omniauth_callback_uid('9101112') # profile_three, member invitation
    get '/auth/github/callback'

    assert_no_difference -> { TeamProfile.admin.count }, -> { TeamProfile.member.count } do
      patch team_member_path(profiles(:profile_one), team_id: teams(:alpha)), params: { role: :member }
    end

    assert_response :forbidden
  end

  test 'invitations can change itself to member' do
    omniauth_callback_uid('9101112') # profile_three, member invitation
    get '/auth/github/callback'

    assert_no_difference -> { TeamProfile.admin.count }, -> { TeamProfile.member.count } do
      patch team_member_path(profiles(:profile_three), team_id: teams(:alpha)), params: { role: :member }
    end

    assert_redirected_to teams(:alpha)
  end

  test 'invitations can not change other invitations to member' do
    omniauth_callback_uid('9101112') # profile_three, member invitation
    get '/auth/github/callback'

    team_profiles(:team_profile2).update!(role: :invitation)

    assert_no_difference -> { TeamProfile.admin.count }, -> { TeamProfile.member.count } do
      patch team_member_path(profiles(:profile_two), team_id: teams(:alpha)), params: { role: :member }
    end

    assert_response :forbidden
  end

  test 'change admin to member fail when team has only one admin' do
    assert_no_difference -> { TeamProfile.admin.count }, -> { TeamProfile.member.count } do
      patch team_member_path(profiles(:profile_one), team_id: teams(:alpha)), params: { role: :member }
    end

    assert_response :unprocessable_entity
  end

  test 'admin can delete member' do
    omniauth_callback_uid(1234) # profile_one, admin role
    get '/auth/github/callback'

    assert_difference -> { TeamProfile.count } => -1 do
      delete team_member_path(profiles(:profile_four), team_id: teams(:alpha))
    end

    assert_response :ok
  end

  test 'member can delete itself' do
    omniauth_callback_uid(5678) # profile_two, memner role
    get '/auth/github/callback'

    assert_difference -> { TeamProfile.count } => -1 do
      delete team_member_path(profiles(:profile_two), team_id: teams(:alpha))
    end

    assert_redirected_to event_profile_path(event_name: events(:party).name)
  end

  test 'member can not delete other ones' do
    omniauth_callback_uid(5678) # profile_two, memner role
    get '/auth/github/callback'

    assert_no_difference -> { TeamProfile.count } do
      delete team_member_path(profiles(:profile_four), team_id: teams(:alpha))
    end

    assert_response :forbidden
  end

  test 'invitation can delete itself' do
    omniauth_callback_uid('9101112') # profile_three, invitation role
    get '/auth/github/callback'

    assert_difference -> { TeamProfile.count } => -1 do
      delete team_member_path(profiles(:profile_three), team_id: teams(:alpha))
    end

    assert_redirected_to event_profile_path(event_name: events(:party).name)
  end

  test 'invitation can not delete other ones' do
    omniauth_callback_uid('9101112') # profile_three, invitation role
    get '/auth/github/callback'

    assert_no_difference -> { TeamProfile.count } do
      delete team_member_path(profiles(:profile_four), team_id: teams(:alpha))
    end

    assert_response :forbidden
  end

  test 'delete member fail when team has only one admin' do
    TeamProfile.find_by(profile: profiles(:profile_two)).destroy
    TeamProfile.find_by(profile: profiles(:profile_three)).destroy

    assert_no_difference -> { TeamProfile.count } do
      delete team_member_path(profiles(:profile_one), team_id: teams(:alpha))
    end

    assert_response :unprocessable_entity
  end
end
