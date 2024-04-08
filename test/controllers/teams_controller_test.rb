# frozen_string_literal: true

require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @team = teams(:alpha)
  end

  test 'should get new' do
    get new_team_url
    assert_response :success
  end

  test 'should create team and creator profile has admin role' do
    team_profiles(:team_profile1).destroy

    omniauth_callback_uid(1234) # profile_one
    get '/auth/github/callback'

    assert_changes -> { [Team.count, TeamProfile.count] } do
      post teams_url, params: { team: { name: 'Charlie' } }
    end

    assert_equal 'admin', TeamProfile.find_by(team: Team.find_by(name: 'Charlie'), profile: profiles(:profile_one)).role

    assert_redirected_to team_url(Team.find_by(name: 'Charlie'))
  end

  test 'should not create team if creator already belongs other team' do
    omniauth_callback_uid(1234) # profile_one
    get '/auth/github/callback'

    assert_no_changes -> { [Team.count, TeamProfile.count] } do
      post teams_url, params: { team: { name: 'Charlie' } }
    end

    assert_response :forbidden
  end

  test 'should return new page when create with invalid param' do
    team_profiles(:team_profile1).destroy

    omniauth_callback_uid(1234) # profile_one
    get '/auth/github/callback'

    assert_no_changes -> { [Team.count, TeamProfile.count] } do
      post teams_url, params: { team: { name: '' } }
    end

    assert_response :unprocessable_entity
  end

  test 'should show team' do
    omniauth_callback_uid(1234) # profile_one
    get '/auth/github/callback'

    get team_url(@team)
    assert_response :success
  end

  test 'should not show team if role is invitation' do
    omniauth_callback_uid('9101112') # profile_three
    get '/auth/github/callback'

    get team_url(@team)
    assert_response :not_found
  end

  test 'should not show team if user has no team_profule relation' do
    TeamProfile.find_by(profile: profiles(:profile_two)).destroy! # profile_two
    omniauth_callback_uid('5678') # profile_two
    get '/auth/github/callback'

    get team_url(@team)
    assert_response :not_found
  end

  test 'should update team' do
    omniauth_callback_uid(1234) # profile_one
    get '/auth/github/callback'

    patch team_url(@team), params: { team: { name: 'Delta' } }
    assert_redirected_to team_url(@team)
  end

  test 'should not update team if operetar is not admin' do
    omniauth_callback_uid(5678) # profile_two
    get '/auth/github/callback'

    patch team_url(@team), params: { team: { name: 'Delta' } }
    assert_response :forbidden
  end

  test 'should destroy team' do
    omniauth_callback_uid(1234) # profile_one
    get '/auth/github/callback'

    assert_difference('Team.count', -1) do
      delete team_url(@team)
    end

    assert_redirected_to teams_url
  end

  test 'should not destroy team if operator is not admin' do
    omniauth_callback_uid(5678) # profile_two
    get '/auth/github/callback'

    assert_no_difference('Team.count') do
      delete team_url(@team)
    end

    assert_response :forbidden
  end
end
