# frozen_string_literal: true

require 'test_helper'

class PlansControllerTest < ActionDispatch::IntegrationTest
  def setup
    omniauth_callback_uid(1234) # profile_one
    get '/auth/github/callback'
  end

  test 'Show plan' do
    get event_plan_path(plans(:one), event_name: events(:party).name)
    assert_response :ok
  end

  test 'Show other persons plan' do
    get event_plan_path(plans(:two), event_name: events(:dojo).name)
    assert_response :ok
  end

  test 'Create plan' do
    assert_difference('Plan.count') do
      post event_plans_path(event_name: events(:dojo).name), params: { plan: { title: 'test', description: 'test', public: true, initial: false } }
    end

    assert_redirected_to event_schedules_path(event_name: events(:dojo).name)
  end

  test 'Create plan with first item' do
    assert_difference('PlanSchedule.count') do
      post event_plans_path(event_name: events(:dojo).name), params: { plan: { title: 'test', description: 'test', public: true, initial: false, add_schedule_id: schedules(:dojo_one).id }}
    end

    assert_redirected_to event_schedules_path(event_name: events(:dojo).name)
  end

  test 'Update plan title' do
    plan = plans(:one)
    patch event_plan_path(plan, event_name: events(:party).name), params: { plan: { title: 'updated title' } }

    plan.reload
    assert_redirected_to event_plan_path(plan, event_name: events(:party).name)
    assert_equal 'updated title', plan.title
  end

  test 'Update plan description' do
    plan = plans(:one)
    patch event_plan_path(plan, event_name: events(:party).name), params: { plan: { description: 'updated desc' } }

    plan.reload
    assert_redirected_to event_plan_path(plan, event_name: events(:party).name)
    assert_equal 'updated desc', plan.description
  end

  test 'Update plan visibility' do
    plan = plans(:one)
    patch event_plan_path(plan, event_name: events(:party).name), params: { plan: { public: false } }

    plan.reload
    assert_redirected_to event_plan_path(plan, event_name: events(:party).name)
    assert_not plan.public
  end

  test 'Reject update plan if user is not own plan' do
    patch event_plan_path(plans(:two), event_name: events(:dojo).name), params: { plan: { title: 'update' } }

    assert_response :forbidden
  end
end
