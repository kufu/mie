# frozen_string_literal: true

require 'test_helper'

class Trigger
  class ConditionTest < ActiveSupport::TestCase
    test '#satisfy? returns true when exists action' do
      ProfileTrophy.create!(profile: profiles(:profile_five), trophy: trophies(:uncommon_trophy))

      condition = Trigger::Condition.new(
        {
          model: 'ProfileTrophy',
          target: 'Profile',
          props: {
            trophy_id: trophies(:uncommon_trophy).id,
            profile_id: 'target'
          },
          action: 'exists'
        },
        profiles(:profile_five)
      )

      assert condition.satisfy?
    end

    test '#satisfy? returns false when exists action' do
      condition = Trigger::Condition.new(
        {
          model: 'ProfileTrophy',
          target: 'Profile',
          props: {
            trophy_id: trophies(:uncommon_trophy).id,
            profile_id: 'target'
          },
          action: 'exists'
        },
        profiles(:profile_five)
      )

      assert_not condition.satisfy?
    end

    test '#satisfy? returns true when not exists action' do
      condition = Trigger::Condition.new(
        {
          model: 'ProfileTrophy',
          target: 'Profile',
          props: {
            trophy_id: trophies(:uncommon_trophy).id,
            profile_id: 'target'
          },
          action: 'not_exists'
        },
        profiles(:profile_five)
      )

      assert condition.satisfy?
    end

    test '#satisfy? returns false when not exists action' do
      ProfileTrophy.create!(profile: profiles(:profile_five), trophy: trophies(:uncommon_trophy))

      condition = Trigger::Condition.new(
        {
          model: 'ProfileTrophy',
          target: 'Profile',
          props: {
            trophy_id: trophies(:uncommon_trophy).id,
            profile_id: 'target'
          },
          action: 'not_exists'
        },
        profiles(:profile_five)
      )

      assert_not condition.satisfy?
    end

    test '#satisfy? returns true when compare action eq' do
      condition = Trigger::Condition.new(
        {
          model: 'Plan',
          target: 'Profile',
          props: {
            id: %i[target user current_plan]
          },
          action: { 'compare' => 'eq', 'value' => 'Test plan', 'attribute' => 'title' }
        },
        profiles(:profile_one)
      )

      assert condition.satisfy?
    end

    test '#satisfy? returns false when compare action eq' do
      condition = Trigger::Condition.new(
        {
          model: 'Plan',
          target: 'Profile',
          props: {
            id: %i[target user current_plan]
          },
          action: { 'compare' => 'eq', 'value' => 'ほげほげ', 'attribute' => 'title' }
        },
        profiles(:profile_one)
      )

      assert_not condition.satisfy?
    end

    test '#satisfy? returns true when compare action not_eq' do
      condition = Trigger::Condition.new(
        {
          model: 'Plan',
          target: 'Profile',
          props: {
            id: %i[target user current_plan]
          },
          action: { 'compare' => 'not_eq', 'value' => 'ほげほげ', 'attribute' => 'title' }
        },
        profiles(:profile_one)
      )

      assert condition.satisfy?
    end

    test '#satisfy? returns false when compare action not_eq' do
      condition = Trigger::Condition.new(
        {
          model: 'Plan',
          target: 'Profile',
          props: {
            id: %i[target user current_plan]
          },
          action: { 'compare' => 'not_eq', 'value' => 'Test plan', 'attribute' => 'title' }
        },
        profiles(:profile_one)
      )

      assert_not condition.satisfy?
    end

    test '#satisfy? returns true when count action eq' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'count' => 1, 'operator' => 'eq' }
        },
        profiles(:profile_one)
      )

      assert condition.satisfy?
    end

    test '#satisfy? returns false when count action eq (greater)' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_three).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'count' => 1, 'operator' => 'eq' }
        },
        profiles(:profile_one)
      )

      assert_not condition.satisfy?
    end

    test '#satisfy? returns false when count action eq (less)' do
      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'count' => 1, 'operator' => 'eq' }
        },
        profiles(:profile_one)
      )

      assert_not condition.satisfy?
    end

    test '#satisfy? returns true when count action gt' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_three).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'count' => 1, 'operator' => 'gt' }
        },
        profiles(:profile_one)
      )

      assert condition.satisfy?
    end

    test '#satisfy? returns false when count action gt' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'count' => 1, 'operator' => 'gt' }
        },
        profiles(:profile_one)
      )

      assert_not condition.satisfy?
    end

    test '#satisfy? returns true when count action gteq' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_three).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'count' => 2, 'operator' => 'gteq' }
        },
        profiles(:profile_one)
      )

      assert condition.satisfy?
    end

    test '#satisfy? returns false when count action gteq' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'count' => 2, 'operator' => 'gteq' }
        },
        profiles(:profile_one)
      )

      assert_not condition.satisfy?
    end

    test '#satisfy? returns true when count action lt' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'count' => 2, 'operator' => 'lt' }
        },
        profiles(:profile_one)
      )

      assert condition.satisfy?
    end

    test '#satisfy? returns false when count action lt' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_three).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'count' => 2, 'operator' => 'lt' }
        },
        profiles(:profile_one)
      )

      assert_not condition.satisfy?
    end

    test '#satisfy? returns true when count action lteq' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'count' => 1, 'operator' => 'lteq' }
        },
        profiles(:profile_one)
      )

      assert condition.satisfy?
    end

    test '#satisfy? returns false when count action lteq' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_three).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'count' => 1, 'operator' => 'lteq' }
        },
        profiles(:profile_one)
      )

      assert_not condition.satisfy?
    end

    test '#satisfy? returns true when include action' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'includes' => [profiles(:profile_two).id], 'attribute' => 'to' }
        },
        profiles(:profile_one)
      )

      assert condition.satisfy?
    end

    test '#satisfy? returns false when include action' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'includes' => [profiles(:profile_three).id], 'attribute' => 'to' }
        },
        profiles(:profile_one)
      )

      assert_not condition.satisfy?
    end

    test '#satisfy? returns true when include action chain methods' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          action: { 'includes' => [profiles(:profile_two).name], 'attribute' => %w[to_profile name] }
        },
        profiles(:profile_one)
      )

      assert condition.satisfy?
    end

    test '#satisfy? returns true when include action chain methods with eager loading' do
      Friend.create!(from: profiles(:profile_one).id, to: profiles(:profile_two).id)

      condition = Trigger::Condition.new(
        {
          model: 'Friend',
          target: 'Profile',
          props: {
            from: 'target'
          },
          eager_load: :to_profile,
          action: { 'includes' => [profiles(:profile_two).name], 'attribute' => %w[to_profile name] }
        },
        profiles(:profile_one)
      )

      assert condition.satisfy?
    end

    test '#satisfy? returns false when props target method chain' do
      condition = Trigger::Condition.new(
        {
          model: 'PlanSchedule',
          target: 'Profile',
          props: {
            plan_id: %w[target user current_plan id]
          },
          action: { 'count' => 1, 'operator' => 'gt' }
        },
        profiles(:profile_two)
      )

      assert_not condition.satisfy?
    end

    test 'raises error when model is not subclass of ApplicationRecord' do
      condition = Trigger::Condition.new(
        {
          model: 'Class',
          target: 'Profile',
          props: {
            plan_id: %w[target user current_plan id]
          },
          action: 'exists'
        },
        profiles(:profile_two)
      )

      assert_raise(Trigger::Condition::InvalidModelError) { condition.satisfy? }
    end

    test 'raises error when target is not subclass of ApplicationRecord' do
      condition = Trigger::Condition.new(
        {
          model: 'PlanSchedule',
          target: 'Class',
          props: {
            plan_id: %w[target user current_plan id]
          },
          action: 'exists'
        },
        profiles(:profile_two)
      )

      assert_raise(Trigger::Condition::InvalidModelError) { condition.satisfy? }
    end

    test 'raises error when undefined action given' do
      condition = Trigger::Condition.new(
        {
          model: 'PlanSchedule',
          target: 'Profile',
          props: {
            plan_id: %w[target user current_plan id]
          },
          action: 'hoge'
        },
        profiles(:profile_two)
      )

      assert_raise(Trigger::Condition::UndefinedActionError) { condition.satisfy? }
    end

    test 'raises error when undefined count operator given' do
      condition = Trigger::Condition.new(
        {
          model: 'PlanSchedule',
          target: 'Profile',
          props: {
            plan_id: %w[target user current_plan id]
          },
          action: { 'count' => 1, 'operator' => 'hoge' }
        },
        profiles(:profile_two)
      )

      assert_raise(Trigger::Condition::UndefinedOperatorError) { condition.satisfy? }
    end
  end
end
