# frozen_string_literal: true

require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  test "returns code 200" do
    get event_schedules_path(event_name: events(:party).name)
    assert_response :success
  end

  test "set variable @schedules for event" do
    get event_schedules_path(event_name: events(:party).name)

    # TODO: don't check private instance variable
    target = @controller.send(:instance_variable_get, :@schedules)
    assert_equal 5, target.length
  end

  test "set variable @schedules for other event" do
    get event_schedules_path(event_name: events(:dojo).name)

    # TODO: don't check private instance variable
    target = @controller.send(:instance_variable_get, :@schedules)
    assert_equal 1, target.length
  end
end
