# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'create new profile when user sign up' do
    omniauth_callback_uid('12345678')
    assert_changes -> { Profile.count } do
      get '/auth/github/callback'
    end
  end

  test "don't create new profile when user already signed up" do
    omniauth_callback_uid('1234') # fixture user
    assert_no_changes -> { Profile.count } do
      get '/auth/github/callback'
    end
  end

  test 'inherit plan if user created plan before sign up' do
    omniauth_callback_uid('12345678')
    post event_plans_path(event_name: events(:kaigi).name), params: {
      plan: {
        title: 'plan for kaigi',
        initial: true,
        add_schedule_id: schedules(:kaigi_day1_time1_track1).id
      }
    }

    assert_no_changes -> { User.find(session[:user_id]).plans.where(event: events(:kaigi)).recent&.first } do
      get '/auth/github/callback'
    end
  end

  test 'remove session' do
    omniauth_callback_uid('1234') # fixture user
    get '/auth/github/callback'
    assert_equal session[:user_id], users(:one).id
    delete '/session'
    assert_nil session[:user_id]
  end
end
