# frozen_string_literal: true

require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  def setup
    omniauth_callback_uid(1234) # profile_one
    get '/auth/github/callback'
  end

  test 'Add new item to plan' do
    assert_difference('PlanSchedule.count', 1) do
      post event_plan_items_url(event_name: events(:party).name, plan_id: plans(:one).id),
           params: { schedule_id: schedules(:six).id }
    end
    assert_redirected_to event_path(events(:party).name)
  end

  test 'Reject add new item to plan when crossover item has exists' do
    assert_no_difference('PlanSchedule.count') do
      post event_plan_items_url(event_name: events(:party).name, plan_id: plans(:one).id),
           params: { schedule_id: schedules(:one_crossover).id }
    end
    assert_redirected_to event_plan_path(plans(:one), event_name: events(:party).name)
  end

  test 'Reject add new item to plan when crossover item has exists with turbo frames' do
    assert_no_difference('PlanSchedule.count') do
      post event_plan_items_url(event_name: events(:party).name, plan_id: plans(:one).id),
           params: { schedule_id: schedules(:one_crossover).id }, as: :turbo_stream
    end
    assert_redirected_to event_plan_path(plans(:one), event_name: events(:party).name)
  end

  test 'Change plan initial flag turn false if add new item succeed' do
    plan = plans(:one)
    plan.initial = true
    plan.save!

    post event_plan_items_url(event_name: events(:party).name, plan_id: plans(:one).id),
         params: { schedule_id: schedules(:six).id }
    plan.reload

    assert_not plan.initial
  end

  test 'Not change plan initial flag turn false if add new item failed' do
    plan = plans(:one)
    plan.initial = true
    plan.save!

    post event_plan_items_url(event_name: events(:party).name, plan_id: plans(:one).id),
         params: { schedule_id: schedules(:one_crossover).id }
    plan.reload

    assert plan.initial
  end

  test 'Reject add item to plan when item is not belongs to event' do
    assert_no_difference('PlanSchedule.count') do
      post event_plan_items_url(event_name: events(:party).name, plan_id: plans(:one).id),
           params: { schedule_id: schedules(:dojo_one).id }
    end
    assert_response :not_found
  end

  test 'Reject add new item to plan that not owned' do
    assert_no_difference('PlanSchedule.count') do
      post event_plan_items_url(event_name: events(:party).name, plan_id: plans(:two).id),
           params: { schedule_id: schedules(:six).id }
    end
    assert_response :forbidden
  end

  test 'Modify items memo' do
    item = plans(:one).plan_schedules.find_by(schedule: schedules(:one))
    patch event_item_url(item, event_name: events(:party).name), params: { plan_schedule: { memo: 'test' } }
    item.reload

    assert_equal 'test', item.memo
  end

  test 'Return bad request when modify items memo unless param' do
    item = plans(:one).plan_schedules.find_by(schedule: schedules(:one))
    patch event_item_url(item, event_name: events(:party).name), params: {}
    assert_response :bad_request
  end

  test 'Reject modify item when item is not owned' do
    item = plans(:two).plan_schedules.create!(schedule: schedules(:dojo_one))
    patch event_item_url(item, event_name: events(:party).name), params: { plan_schedule: { memo: 'test' } }
    assert_response :forbidden
  end

  test 'Remove item from plan' do
    plan = plans(:one)
    item = plan.plan_schedules.find_by(schedule: schedules(:one))

    assert_difference('PlanSchedule.count', -1) do
      delete event_item_url(item, event_name: events(:party).name)
    end

    assert_redirected_to event_path(events(:party).name)
  end

  test 'Reject delete other users item' do
    plan = plans(:two)
    item = plan.plan_schedules.create!(schedule: schedules(:dojo_one))

    assert_no_difference('PlanSchedule.count') do
      delete event_item_url(item, event_name: events(:party).name)
    end

    assert_response :forbidden
  end

  test 'Reject delete other event item' do
    user = users(:one)
    plan = user.plans.create!(event: events(:dojo), title: 'delete test')
    item = plan.plan_schedules.create!(schedule: schedules(:dojo_one))

    assert_no_difference('PlanSchedule.count') do
      delete event_item_url(item, event_name: events(:party).name)
    end

    assert_response :not_found
  end
end
