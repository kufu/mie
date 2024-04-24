# frozen_string_literal: true

require 'test_helper'

class TriggerTest < ActiveSupport::TestCase
  test 'Hash action valid' do
    assert_difference -> { Trigger.count } => 1 do
      Trigger.create!(
        description: 'test trigger',
        key: 'testkey',
        action: {
          model: 'ProfileTrophy',
          target: 'Profile',
          props: {
            trophy_id: trophies(:common_trophy).id,
            profile_id: :target
          },
          action: :craete
        },
        amount: 1
      )
    end
  end

  test 'Array action valid' do
    assert_difference -> { Trigger.count } => 1 do
      Trigger.create!(
        description: 'test trigger',
        key: 'testkey',
        action: [{
          model: 'ProfileTrophy',
          target: 'Profile',
          props: {
            trophy_id: trophies(:common_trophy).id,
            profile_id: :target
          },
          action: :craete
        }],
        amount: 1
      )
    end
  end

  test 'JSON string action valid' do
    action = <<-"JSON"
      {
        "model": "ProfileTrophy",
        "target": "Profile",
        "props": {
          "trophy_id": "#{trophies(:common_trophy).id}",
          "profile_id": "target"
        },
        "action": "craete"
      }
    JSON
    assert_difference -> { Trigger.count } => 1 do
      Trigger.create!(
        description: 'test trigger',
        key: 'testkey',
        action:,
        amount: 1
      )
    end
  end

  test 'non-JSON string action invalid' do
    assert_no_difference -> { Trigger.count } do
      Trigger.create(
        description: 'test trigger',
        key: 'testkey',
        action: 'NO JSON STRING',
        amount: 1
      )
    end
  end

  test '#perform can add trophy record for profile' do
    trigger = Trigger.create(
      description: 'test trigger',
      key: 'testkey',
      action: {
        model: 'ProfileTrophy',
        target: 'Profile',
        props: {
          trophy_id: trophies(:common_trophy).id,
          profile_id: :target
        },
        action: :craete
      },
      amount: 1
    )

    assert_difference -> { ProfileTrophy.count } => 1 do
      trigger.perform(profiles(:profile_two), 'testkey')
    end

    assert profiles(:profile_two).trophies.include?(trophies(:common_trophy))
  end

  test '#perform can add trophy record for profile(action is array)' do
    trigger = Trigger.create(
      description: 'test trigger',
      key: 'testkey',
      action: [
        {
          model: 'ProfileTrophy',
          target: 'Profile',
          props: {
            trophy_id: trophies(:common_trophy).id,
            profile_id: :target
          },
          action: :craete
        }
      ],
      amount: 1
    )

    assert_difference -> { ProfileTrophy.count } => 1 do
      trigger.perform(profiles(:profile_two), 'testkey')
    end

    assert profiles(:profile_two).trophies.include?(trophies(:common_trophy))
  end

  test '#perform decreases amount' do
    trigger = Trigger.create(
      description: 'test trigger',
      key: 'testkey',
      action: {
        model: 'ProfileTrophy',
        target: 'Profile',
        props: {
          trophy_id: trophies(:common_trophy).id,
          profile_id: :target
        },
        action: :craete
      },
      amount: 2
    )

    assert_difference -> { trigger.amount } => -1 do
      trigger.perform(profiles(:profile_two), 'testkey')
      trigger.reload
    end
  end

  test '#perform can trigger action when time is before expires' do
    trigger = Trigger.create(
      description: 'test trigger',
      key: 'testkey',
      action: {
        model: 'ProfileTrophy',
        target: 'Profile',
        props: {
          trophy_id: trophies(:common_trophy).id,
          profile_id: :target
        },
        action: :craete
      },
      amount: 2,
      expires_at: Time.zone.local(2024, 4, 21, 10, 0, 0)
    )

    travel_to Time.zone.local(2024, 4, 21, 9, 59, 59) do
      assert_difference -> { ProfileTrophy.count } => 1 do
        trigger.perform(profiles(:profile_two), 'testkey')
      end

      assert profiles(:profile_two).trophies.include?(trophies(:common_trophy))
    end
  end

  test '#perform raises error when key is not match' do
    trigger = Trigger.create(
      description: 'test trigger',
      key: 'testkey',
      action: {
        model: 'ProfileTrophy',
        target: 'Profile',
        props: {
          trophy_id: trophies(:common_trophy).id,
          profile_id: :target
        },
        action: :craete
      },
      amount: 1
    )

    e = assert_raise(Trigger::KeyNotMatchError) do
      trigger.perform(profiles(:profile_two), 'wrongkey')
    end

    assert_equal 'key is not match', e.message
  end

  test '#perform raises error when model name is not constant' do
    trigger = Trigger.create(
      description: 'test trigger',
      key: 'testkey',
      action: {
        model: 'profileTrophy', # Not Constant
        target: 'Profile',
        props: {
          trophy_id: trophies(:common_trophy).id,
          profile_id: :target
        },
        action: :craete
      },
      amount: 1
    )

    e = assert_raise(Trigger::Action::ParseError) do
      trigger.perform(profiles(:profile_two), 'testkey')
    end

    assert_equal 'profileTrophy is not valid model name', e.message
  end

  test '#perform raises error when model name is not ActiveRecord subclass' do
    trigger = Trigger.create(
      description: 'test trigger',
      key: 'testkey',
      action: {
        model: 'MembersController', # Not ActiveRecord subclass
        target: 'Profile',
        props: {
          trophy_id: trophies(:common_trophy).id,
          profile_id: :target
        },
        action: :craete
      },
      amount: 1
    )

    e = assert_raise(Trigger::Action::ParseError) do
      trigger.perform(profiles(:profile_two), 'testkey')
    end

    assert_equal 'MembersController is not ActiveRecord models', e.message
  end

  test '#perform can not trigger action when amount less than equal 0' do
    trigger = Trigger.create(
      description: 'test trigger',
      key: 'testkey',
      action: {
        model: 'ProfileTrophy',
        target: 'Profile',
        props: {
          trophy_id: trophies(:common_trophy).id,
          profile_id: :target
        },
        action: :craete
      },
      amount: 0
    )

    e = assert_raise(Trigger::NoLeftError) do
      trigger.perform(profiles(:profile_two), 'testkey')
    end

    assert_equal 'Sold out', e.message
  end

  test '#perform can not trigger action when time is after expires' do
    trigger = Trigger.create(
      description: 'test trigger',
      key: 'testkey',
      action: {
        model: 'ProfileTrophy',
        target: 'Profile',
        props: {
          trophy_id: trophies(:common_trophy).id,
          profile_id: :target
        },
        action: :craete
      },
      amount: 1,
      expires_at: Time.zone.local(2024, 4, 21, 10, 0, 0)
    )

    travel_to Time.zone.local(2024, 4, 21, 10, 0, 1) do
      e = assert_raise(Trigger::ExpiresError) do
        trigger.perform(profiles(:profile_two), 'testkey')
      end

      assert_equal 'This trigger is expired', e.message
    end
  end

  test '#refresh_key regenerate new key' do
    trigger = Trigger.create(
      description: 'test trigger',
      key: 'testkey',
      action: {
        model: 'ProfileTrophy',
        target: 'Profile',
        props: {
          trophy_id: trophies(:common_trophy).id,
          profile_id: :target
        },
        action: :craete
      },
      amount: 1,
      expires_at: Time.zone.local(2024, 4, 21, 10, 0, 0)
    )

    assert_changes -> { trigger.key } do
      trigger.refresh_key
    end
  end
end
