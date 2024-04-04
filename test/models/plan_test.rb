# frozen_string_literal: true

require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  test 'title length must greater than 0, less than 100' do
    p = plans(:one)

    p.title = ''
    assert_not p.valid?

    p.title = 'Something new'
    assert p.valid?

    p.title = 'あ' * 100
    assert p.valid?

    p.title = 'い' * 101
    assert_not p.valid?
  end

  test 'description length must greater equal than 0, less than 1024' do
    p = plans(:one)

    p.description = nil
    assert_not p.valid?

    p.description = ''
    assert p.valid?

    p.description = 'Yeah'
    assert p.valid?

    p.description = 'あ' * 1024
    assert p.valid?

    p.description = 'い' * 1025
    assert_not p.valid?
  end

  test 'public status must be present' do
    p = plans(:one)

    p.public = nil
    assert_not p.valid?
  end

  test 'set public false default when instance created' do
    assert_not Plan.create(title: 'test').public?
  end

  test "Can't select schedules that same start-end time" do
    schs = schedules(:four, :five)

    p = Plan.create!(title: 'test', user: User.create!, event: events(:party))
    p.plan_schedules.create(schedule: schs[0])
    p.plan_schedules.create(schedule: schs[1])
    assert_not p.valid?
  end

  test "Can't select schedules that overlap start-end time" do
    johnny, kerry = speakers(:johnny, :kerry)
    left = Schedule.create!(
      title: 'test1',
      track: tracks(:party_track_a),
      speakers: [johnny],
      start_at: Time.zone.parse('2021-07-30 12:00:00'),
      end_at: Time.zone.parse('2021-07-30 13:00:00'),
      event: events(:party)
    )
    right = Schedule.create!(
      title: 'test2',
      track: tracks(:party_track_b),
      speakers: [kerry],
      start_at: Time.zone.parse('2021-07-30 12:30:00'),
      end_at: Time.zone.parse('2021-07-30 13:20:00'),
      event: events(:party)
    )

    p = Plan.create!(title: 'test', user: User.create!, event: events(:party))
    p.plan_schedules.create(schedule: left)
    p.plan_schedules.create(schedule: right)
    assert_not p.valid?
  end

  test 'select schedules first schedule end_at equals second schedule start_at' do
    johnny, kerry = speakers(:johnny, :kerry)
    left = Schedule.create!(
      title: 'test1',
      track: tracks(:party_track_a),
      speakers: [johnny],
      start_at: Time.zone.parse('2021-07-30 12:00:00'),
      end_at: Time.zone.parse('2021-07-30 13:00:00'),
      event: events(:party)
    )
    right = Schedule.create!(
      title: 'test2',
      track: tracks(:party_track_a),
      speakers: [kerry],
      start_at: Time.zone.parse('2021-07-30 13:00:00'),
      end_at: Time.zone.parse('2021-07-30 14:00:00'),
      event: events(:party)
    )

    p = Plan.create!(title: 'test', user: User.create!, event: events(:party))
    p.plan_schedules.create(schedule: left)
    p.plan_schedules.create(schedule: right)
    assert p.valid?
  end
end
