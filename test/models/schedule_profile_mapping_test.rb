# frozen_string_literal: true

require 'test_helper'

class ScheduleProfileMappingTest < ActiveSupport::TestCase
  test 'create schedule profile mapping' do
    user1 = User.create!
    profile1 = user1.create_profile!(name: 'user1', provider: 'test', uid: 'test1', avatar_url: 'https://example.com')
    user1.plans.create!(title: 'test1', event: events(:party)).tap do |plan|
      plan.plan_schedules.create!(schedule: schedules(:one))
      plan.plan_schedules.create!(schedule: schedules(:two))
      plan.plan_schedules.create!(schedule: schedules(:three))
      plan.save!
    end

    user2 = User.create!
    profile2 = user2.create_profile!(name: 'user2', provider: 'test', uid: 'test2', avatar_url: 'https://example.com')
    user2.plans.create!(title: 'test1', event: events(:party)).tap do |plan|
      plan.plan_schedules.create!(schedule: schedules(:one_crossover))
      plan.plan_schedules.create!(schedule: schedules(:four))
      plan.plan_schedules.create!(schedule: schedules(:six))
      plan.save!
    end

    mapping = ScheduleProfileMapping.new([profile1, profile2], events(:party))
    assert_equal [schedules(:one).id, schedules(:two).id, schedules(:three).id].sort, mapping.fetch(profile1).sort
    assert_equal [schedules(:one_crossover).id, schedules(:four).id, schedules(:six).id].sort,
                 mapping.fetch(profile2).sort
  end

  test 'schedule profile mapping returns empty array when profile has no plan' do
    user1 = User.create!
    profile1 = user1.create_profile!(name: 'user1', provider: 'test', uid: 'test1', avatar_url: 'https://example.com')
    user1.plans.create!(title: 'test1', event: events(:party)).tap do |plan|
      plan.plan_schedules.create!(schedule: schedules(:one))
      plan.plan_schedules.create!(schedule: schedules(:two))
      plan.plan_schedules.create!(schedule: schedules(:three))
      plan.save!
    end

    user2 = User.create!
    profile2 = user2.create_profile!(name: 'user2', provider: 'test', uid: 'test2', avatar_url: 'https://example.com')

    mapping = ScheduleProfileMapping.new([profile1, profile2], events(:party))
    assert_equal [schedules(:one).id, schedules(:two).id, schedules(:three).id].sort, mapping.fetch(profile1).sort
    assert_equal [], mapping.fetch(profile2)
  end

  test 'create schedule profile mapping only passed event' do
    user1 = User.create!
    profile1 = user1.create_profile!(name: 'user1', provider: 'test', uid: 'test1', avatar_url: 'https://example.com')
    user1.plans.create!(title: 'test1', event: events(:party)).tap do |plan|
      plan.plan_schedules.create!(schedule: schedules(:one))
      plan.plan_schedules.create!(schedule: schedules(:two))
      plan.plan_schedules.create!(schedule: schedules(:three))
      plan.save!
    end

    user1.plans.create!(title: 'test1 kaigi', event: events(:kaigi)).tap do |plan|
      plan.plan_schedules.create!(schedule: schedules(:kaigi_day1_time1_track1))
      plan.plan_schedules.create!(schedule: schedules(:kaigi_day1_time2_track1))
      plan.plan_schedules.create!(schedule: schedules(:kaigi_day1_time3_track1))
      plan.save!
    end

    mapping = ScheduleProfileMapping.new([profile1], events(:party))
    assert_equal [schedules(:one).id, schedules(:two).id, schedules(:three).id].sort, mapping.fetch(profile1).sort

    mapping = ScheduleProfileMapping.new([profile1], events(:kaigi))
    assert_equal(
      [
        schedules(:kaigi_day1_time1_track1).id,
        schedules(:kaigi_day1_time2_track1).id,
        schedules(:kaigi_day1_time3_track1).id
      ].sort,
      mapping.fetch(profile1).sort
    )
  end

  test 'mapping returns updated_at that most latest updated_at all profiles' do
    current = Time.current

    user1 = User.create!
    profile1 = user1.create_profile!(name: 'user1', provider: 'test', uid: 'test1', avatar_url: 'https://example.com')
    user1.plans.create!(title: 'test1', event: events(:party)).tap do |plan|
      plan.plan_schedules.create!(schedule: schedules(:one))
      plan.plan_schedules.create!(schedule: schedules(:two))
      plan.plan_schedules.create!(schedule: schedules(:three))
      plan.update!(updated_at: current - 2.minute)
    end

    user2 = User.create!
    profile2 = user2.create_profile!(name: 'user2', provider: 'test', uid: 'test2', avatar_url: 'https://example.com')
    user2.plans.create!(title: 'test1', event: events(:party)).tap do |plan|
      plan.plan_schedules.create!(schedule: schedules(:one_crossover))
      plan.plan_schedules.create!(schedule: schedules(:four))
      plan.plan_schedules.create!(schedule: schedules(:six))
      plan.update!(updated_at: current - 1.minutes)
    end

    mapping = ScheduleProfileMapping.new([profile1, profile2], events(:party))
    assert_equal (current - 1.minute).to_fs(:usec), mapping.updated_at.to_fs(:usec)
  end

  test '#[] are alias of #fetch' do
    user1 = User.create!
    profile1 = user1.create_profile!(name: 'user1', provider: 'test', uid: 'test1', avatar_url: 'https://example.com')
    user1.plans.create!(title: 'test1', event: events(:party)).tap do |plan|
      plan.plan_schedules.create!(schedule: schedules(:one))
      plan.plan_schedules.create!(schedule: schedules(:two))
      plan.plan_schedules.create!(schedule: schedules(:three))
      plan.save!
    end

    mapping = ScheduleProfileMapping.new([profile1], events(:party))
    assert_equal [schedules(:one).id, schedules(:two).id, schedules(:three).id].sort, mapping[profile1].sort
  end

  test '#cache_key returns string key' do
    user1 = User.create!
    profile1 = user1.create_profile!(name: 'user1', provider: 'test', uid: 'test1', avatar_url: 'https://example.com')
    user1.plans.create!(title: 'test1', event: events(:party)).tap do |plan|
      plan.plan_schedules.create!(schedule: schedules(:one))
      plan.plan_schedules.create!(schedule: schedules(:two))
      plan.plan_schedules.create!(schedule: schedules(:three))
      plan.save!
    end

    mapping = ScheduleProfileMapping.new([profile1], events(:party))
    assert_equal String, mapping.cache_key.class
  end

  test '#id returns different value if profiles is not equal' do
    user1 = User.create!
    profile1 = user1.create_profile!(name: 'user1', provider: 'test', uid: 'test1', avatar_url: 'https://example.com')
    user1.plans.create!(title: 'test1', event: events(:party)).tap do |plan|
      plan.plan_schedules.create!(schedule: schedules(:one))
      plan.plan_schedules.create!(schedule: schedules(:two))
      plan.plan_schedules.create!(schedule: schedules(:three))
      plan.save!
    end

    user2 = User.create!
    profile2 = user2.create_profile!(name: 'user2', provider: 'test', uid: 'test2', avatar_url: 'https://example.com')
    user2.plans.create!(title: 'test1', event: events(:party)).tap do |plan|
      plan.plan_schedules.create!(schedule: schedules(:one_crossover))
      plan.plan_schedules.create!(schedule: schedules(:four))
      plan.plan_schedules.create!(schedule: schedules(:six))
      plan.save!
    end

    mapping1 = ScheduleProfileMapping.new([profile1], events(:party))
    mapping2 = ScheduleProfileMapping.new([profile1, profile2], events(:party))

    assert_not_equal mapping1.id, mapping2.id
  end
end
