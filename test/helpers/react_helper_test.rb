# frozen_string_literal: true

require 'test_helper'

class ReactHelperTest < ActionView::TestCase
  # mock method
  def form_authenticity_token(_)
    'test'
  end

  test 'schedule_to_card_props_with_includes_plan' do
    sch = schedules(:one)
    plan = plans(:one)
    expect = {
      title: sch.title,
      description: sch.description,
      speakerName: sch.speaker.name,
      thumbnailUrl: sch.speaker.thumbnail,
      language: sch.language,
      action: plan_path(plan),
      method: 'patch',
      authenticityToken: form_authenticity_token(''),
      targetKeyName: 'remove_schedule_id',
      targetKey: sch.id,
      buttonText: 'remove'
    }
    assert_equal expect, schedule_to_card_props(sch, plan)
  end

  test 'schedule_to_card_props_without_includes_plan' do
    sch = schedules(:four)
    plan = plans(:one)
    expect = {
      title: sch.title,
      description: sch.description,
      speakerName: sch.speaker.name,
      thumbnailUrl: sch.speaker.thumbnail,
      language: sch.language,
      action: plan_path(plan),
      method: 'patch',
      authenticityToken: form_authenticity_token(''),
      targetKeyName: 'add_schedule_id',
      targetKey: sch.id,
      buttonText: 'add'
    }
    assert_equal expect, schedule_to_card_props(sch, plan)
  end

  test 'create_schedule_table_props' do
    schs = schedules(:one, :two, :three, :four, :five)
    plan = plans(:one)
    table_array = Class.new { include SchedulesHelper }.new.create_table_array(schs)

    expect = {
      '2021-07-20' => {
        trackList: %w[TrackA TrackB],
        rows: [
          { time: '10:00:00 - 10:40:00', schedules: [schedule_to_card_props(schs[0], plan), nil] },
          { time: '11:00:00 - 11:40:00', schedules: [nil, schedule_to_card_props(schs[1], plan)] }
        ]
      },
      '2021-07-21' => {
        trackList: %w[TrackA TrackB TrackC],
        rows: [
          { time: '10:00:00 - 10:40:00', schedules: [schedule_to_card_props(schs[2], plan), nil, nil] },
          { time: '11:00:00 - 11:40:00',
            schedules: [nil, schedule_to_card_props(schs[3], plan), schedule_to_card_props(schs[4], plan)] }
        ]
      }
    }
    assert_equal expect, create_schedule_table_props(table_array, plan)
  end

  test 'create_plan_table_props' do
    plan = plans(:one)
    schs = schedules(:one, :two, :three, :five)

    expect = {
      '2021-07-20' => [
        { time: '10:00:00 - 10:40:00', schedule: schedule_to_card_props(schs[0], plan) },
        { time: '11:00:00 - 11:40:00', schedule: schedule_to_card_props(schs[1], plan) }
      ],
      '2021-07-21' => [
        { time: '10:00:00 - 10:40:00', schedule: schedule_to_card_props(schs[2], plan) },
        { time: '11:00:00 - 11:40:00', schedule: schedule_to_card_props(schs[3], plan) }
      ]
    }
    assert_equal expect, create_plan_table_props(plan)
  end
end
