# frozen_string_literal: true

require 'test_helper'

class Trigger
  class ConditionsTest < ActiveSupport::TestCase
    test '#satisfy? returns true when initialized with empty array' do
      conditions = Trigger::Conditions.new([], nil)
      assert conditions.satisfy?
    end

    test '#satisfy? returns true when satisfied conditions given' do
      Friend.create!(from: profiles(:profile_five).id, to: profiles(:profile_one).id)

      conditions = Trigger::Conditions.new(
        [
          {
            model: 'ProfileTrophy',
            target: 'Profile',
            props: {
              trophy_id: trophies(:uncommon_trophy).id,
              profile_id: 'target'
            },
            action: 'not_exists'
          },
          {
            model: 'Friend',
            target: 'Profile',
            props: {
              from: :target
            },
            action: { 'operator' => 'gteq', 'count' => 0 }
          }
        ],
        profiles(:profile_five)
      )

      assert conditions.satisfy?
    end

    test '#satisfy? returns false when satisfied conditions given' do
      ProfileTrophy.create!(profile: profiles(:profile_five), trophy: trophies(:uncommon_trophy))
      Friend.create!(from: profiles(:profile_five).id, to: profiles(:profile_one).id)

      conditions = Trigger::Conditions.new(
        [
          {
            model: 'ProfileTrophy',
            target: 'Profile',
            props: {
              trophy_id: trophies(:uncommon_trophy).id,
              profile_id: 'target'
            },
            action: 'not_exists'
          },
          {
            model: 'Friend',
            target: 'Profile',
            props: {
              from: 'target'
            },
            action: { 'operator' => 'gteq', 'count' => 0 }
          }
        ],
        profiles(:profile_five)
      )

      assert_not conditions.satisfy?
    end
  end
end
