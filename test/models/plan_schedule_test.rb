# frozen_string_literal: true

require 'test_helper'

class PlanScheduleTest < ActiveSupport::TestCase
  test 'assign schedule to plan on same event' do
    target = PlanSchedule.create(schedule: schedules(:one), plan: plans(:one))
    assert target.valid?
  end

  test "Can't assign schedule to plan managed by other event" do
    target = PlanSchedule.create(schedule: schedules(:dojo_one), plan: plans(:one))
    assert target.invalid?
  end
end
