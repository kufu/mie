# frozen_string_literal: true

require 'test_helper'

class TriggersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @trigger = Trigger.create(
      description: 'test trigger',
      key: 'testkey',
      action: {
        model: 'ProfileTrophy',
        target: 'Profile',
        props: {
          trophy_id: trophies(:rare_trophy).id,
          profile_id: :target
        },
        action: :craete
      },
      amount: 1
    )
  end

  test 'trigger action' do
    omniauth_callback_uid(1234) # profile_one
    get '/auth/github/callback'

    assert_difference -> { ProfileTrophy.count } => 1 do
      get trigger_path(@trigger, key: 'testkey')
    end
  end

  test 'trigger action requires profile' do
    assert_no_difference -> { ProfileTrophy.count } do
      get trigger_path(@trigger, key: 'testkey')
    end

    assert_redirected_to event_profile_path
  end
end
