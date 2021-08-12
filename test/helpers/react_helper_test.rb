# frozen_string_literal: true

require 'test_helper'

class ReactHelperTest < ActionView::TestCase
  # mock method
  def form_authenticity_token(_)
    'test'
  end

  test 'schedule_to_card_props_with_includes_plan' do
    user = users(:one)
    sch = schedules(:one)
    plan = plans(:one)
    expect = {
      title: sch.title,
      description: sch.description,
      speakerName: sch.speaker.name,
      thumbnailUrl: sch.speaker.thumbnail,
      language: sch.language,
      form: {
        action: plan_path(plan),
        method: 'patch',
        authenticityToken: form_authenticity_token(''),
        targetKeyName: 'remove_schedule_id',
        targetKey: sch.id,
        buttonText: 'remove'
      }
    }
    assert_equal expect, schedule_to_card_props(sch, plan, user)
  end

  test 'schedule_to_card_props_without_includes_plan' do
    user = users(:one)
    sch = schedules(:four)
    plan = plans(:one)
    expect = {
      title: sch.title,
      description: sch.description,
      speakerName: sch.speaker.name,
      thumbnailUrl: sch.speaker.thumbnail,
      language: sch.language,
      form: {
        action: plan_path(plan),
        method: 'patch',
        authenticityToken: form_authenticity_token(''),
        targetKeyName: 'add_schedule_id',
        targetKey: sch.id,
        buttonText: 'add'
      }
    }
    assert_equal expect, schedule_to_card_props(sch, plan, user)
  end

  test 'schedule_to_card_props_with_no_plan_args' do
    user = users(:one)
    sch = schedules(:one)
    expect = {
      title: sch.title,
      description: sch.description,
      speakerName: sch.speaker.name,
      thumbnailUrl: sch.speaker.thumbnail,
      language: sch.language
    }
    assert_equal expect, schedule_to_card_props(sch, nil, user)
  end

  test 'schedule_to_card_props_with_plan_user_not_own' do
    user = users(:two)
    sch = schedules(:one)
    plan = plans(:one)
    expect = {
      title: sch.title,
      description: sch.description,
      speakerName: sch.speaker.name,
      thumbnailUrl: sch.speaker.thumbnail,
      language: sch.language
    }
    assert_equal expect, schedule_to_card_props(sch, plan, user)
  end

  test 'create_schedule_table_props' do
    usr = users(:one)
    schs = schedules(:one, :two, :three, :four, :five)
    plan = plans(:one)
    table_array = Class.new { include SchedulesHelper }.new.create_table_array(schs)

    expect = {
      groupedSchedules: {
        '2021-07-20' => {
          trackList: %w[TrackA TrackB],
          rows: [
            { time: '10:00 - 10:40 (UTC)', schedules: [schedule_to_card_props(schs[0], plan, usr), nil] },
            { time: '11:00 - 11:40 (UTC)', schedules: [nil, schedule_to_card_props(schs[1], plan, usr)] }
          ]
        },
        '2021-07-21' => {
          trackList: %w[TrackA TrackB TrackC],
          rows: [
            { time: '10:00 - 10:40 (UTC)', schedules: [schedule_to_card_props(schs[2], plan, usr), nil, nil] },
            { time: '11:00 - 11:40 (UTC)', schedules: [nil] + schs[3..4].map { schedule_to_card_props(_1, plan, usr) } }
          ]
        }
      },
      current: '2021-07-20',
      i18n: { startEnd: 'Start...End time' }
    }
    assert_equal expect, create_schedule_table_props(table_array, plan, usr)
  end

  test 'create_plan_table_props_user_own' do
    user = users(:one)
    plan = plans(:one)
    schs = schedules(:one, :two, :three, :five)

    expect = {
      groupedPlans: {
        '2021-07-20' => [
          { time: '10:00 - 10:40 (UTC)', schedule: schedule_to_card_props(schs[0], plan, user),
            memo: plan.plan_schedules.find_by(schedule: schs[0]).memo },
          { time: '11:00 - 11:40 (UTC)', schedule: schedule_to_card_props(schs[1], plan, user),
            memo: plan.plan_schedules.find_by(schedule: schs[1]).memo }
        ],
        '2021-07-21' => [
          { time: '10:00 - 10:40 (UTC)', schedule: schedule_to_card_props(schs[2], plan, user),
            memo: plan.plan_schedules.find_by(schedule: schs[2]).memo },
          { time: '11:00 - 11:40 (UTC)', schedule: schedule_to_card_props(schs[3], plan, user),
            memo: plan.plan_schedules.find_by(schedule: schs[3]).memo }
        ]
      },
      current: '2021-07-20',
      i18n: { startEnd: 'Start...End time', track: 'Track name', memo: 'Memo', updateMemo: 'Update memo' }
    }
    assert_equal expect, create_plan_table_props(plan, user)
  end

  test 'create_plan_table_props_user_not_own' do
    user = users(:two)
    plan = plans(:one)
    schs = schedules(:one, :two, :three, :five)

    expect = {
      groupedPlans: {
        '2021-07-20' => [
          { time: '10:00 - 10:40 (UTC)', schedule: schedule_to_card_props(schs[0], plan, user),
            memo: plan.plan_schedules.find_by(schedule: schs[0]).memo },
          { time: '11:00 - 11:40 (UTC)', schedule: schedule_to_card_props(schs[1], plan, user),
            memo: plan.plan_schedules.find_by(schedule: schs[1]).memo }
        ],
        '2021-07-21' => [
          { time: '10:00 - 10:40 (UTC)', schedule: schedule_to_card_props(schs[2], plan, user),
            memo: plan.plan_schedules.find_by(schedule: schs[2]).memo },
          { time: '11:00 - 11:40 (UTC)', schedule: schedule_to_card_props(schs[3], plan, user),
            memo: plan.plan_schedules.find_by(schedule: schs[3]).memo }
        ]
      },
      current: '2021-07-20',
      i18n: { startEnd: 'Start...End time', track: 'Track name', memo: 'Memo', updateMemo: 'Update memo' }
    }
    assert_equal expect, create_plan_table_props(plan, user)
  end

  test 'create_info_panel_props' do
    expect = {
      form: {
        action: '/plans',
        authenticityToken: form_authenticity_token('/plans')
      },
      i18n: {
        title: I18n.t('info.create_plan_title'),
        openText: I18n.t('button.open_text'),
        closeText: I18n.t('button.close_text'),
        information: I18n.t('info.create_plan_text'),
        termsOfService: I18n.t('info.terms_of_service'),
        buttonText: I18n.t('button.plan_create_button')
      }
    }
    assert_equal expect, create_info_panel_props
  end
end
