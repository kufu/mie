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
      mode: 'list',
      description: sch.description,
      trackName: sch.track_name,
      speakers: sch.speakers.map do |speaker|
        {
          speakerName: speaker.name,
          thumbnailUrl: speaker.thumbnail
        }
      end,
      language: sch.language,
      details: {
        body: {
          speakers: sch.speakers.map do |speaker|
            {
              thumbnailUrl: speaker.thumbnail,
              speaker: speaker.name,
              username: speaker.handle,
              aboutSpeaker: speaker.profile,
              github: speaker.github,
              twitter: speaker.twitter
            }
          end,
          startEndTime: "#{I18n.l(sch.start_at, format: :default)} - #{I18n.l(sch.end_at, format: :timetable)}",
          language: sch.language,
          description: sch.description,
          i18n: {
            speaker: I18n.t('card.detail.speaker'),
            username: I18n.t('card.detail.username'),
            aboutSpeaker: I18n.t('card.detail.about_speaker'),
            startEndTime: I18n.t('card.detail.start_end_time', zone: sch.start_at.zone),
            language: I18n.t('card.detail.language'),
            description: I18n.t('card.detail.description')
          }
        },
        i18n: {
          title: I18n.t('card.detail.title'),
          close: I18n.t('button.close')
        }
      },
      memo: '',
      memoMaxLength: 1024,
      form: {
        action: event_plan_path(plan, event_name: plan.event.name),
        method: 'patch',
        authenticityToken: form_authenticity_token(''),
        targetKeyName: 'remove_schedule_id',
        targetKey: sch.id,
        buttonText: I18n.t('card.remove'),
        mode: 'list',
        i18n: {
          added: I18n.t('card.added')
        }
      },
      i18n: {
        showDetail: I18n.t('card.show_detail'),
        editMemo: I18n.t('button.update_memo'),
        title: I18n.t('dialog.edit_memo', title: sch.title),
        save: I18n.t('button.save'),
        close: I18n.t('button.close')
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
      mode: 'list',
      description: sch.description,
      trackName: sch.track_name,
      speakers: sch.speakers.map do |speaker|
        {
          speakerName: speaker.name,
          thumbnailUrl: speaker.thumbnail
        }
      end,
      language: sch.language,
      details: {
        body: {
          speakers: sch.speakers.map do |speaker|
            {
              thumbnailUrl: speaker.thumbnail,
              speaker: speaker.name,
              username: speaker.handle,
              aboutSpeaker: speaker.profile,
              github: speaker.github,
              twitter: speaker.twitter
            }
          end,
          startEndTime: "#{I18n.l(sch.start_at, format: :default)} - #{I18n.l(sch.end_at, format: :timetable)}",
          language: sch.language,
          description: sch.description,
          i18n: {
            speaker: I18n.t('card.detail.speaker'),
            username: I18n.t('card.detail.username'),
            aboutSpeaker: I18n.t('card.detail.about_speaker'),
            startEndTime: I18n.t('card.detail.start_end_time', zone: sch.start_at.zone),
            language: I18n.t('card.detail.language'),
            description: I18n.t('card.detail.description')
          }
        },
        i18n: {
          title: I18n.t('card.detail.title'),
          close: I18n.t('button.close')
        }
      },
      memo: '',
      memoMaxLength: 1024,
      form: {
        action: event_plan_path(plan, event_name: plan.event.name),
        method: 'patch',
        authenticityToken: form_authenticity_token(''),
        targetKeyName: 'add_schedule_id',
        targetKey: sch.id,
        buttonText: I18n.t('card.add'),
        mode: 'list',
        i18n: {
          added: nil
        }
      },
      i18n: {
        showDetail: I18n.t('card.show_detail'),
        editMemo: I18n.t('button.update_memo'),
        title: I18n.t('dialog.edit_memo', title: sch.title),
        save: I18n.t('button.save'),
        close: I18n.t('button.close')
      }
    }
    assert_equal expect, schedule_to_card_props(sch, plan, user)
  end

  test 'schedule_to_card_props_with_no_plan_args' do
    user = users(:one)
    sch = schedules(:one)

    expect = {
      title: sch.title,
      mode: 'list',
      description: sch.description,
      trackName: sch.track_name,
      speakers: sch.speakers.map do |speaker|
        {
          speakerName: speaker.name,
          thumbnailUrl: speaker.thumbnail
        }
      end,
      language: sch.language,
      details: {
        body: {
          speakers: sch.speakers.map do |speaker|
            {
              thumbnailUrl: speaker.thumbnail,
              speaker: speaker.name,
              username: speaker.handle,
              aboutSpeaker: speaker.profile,
              github: speaker.github,
              twitter: speaker.twitter
            }
          end,
          startEndTime: "#{I18n.l(sch.start_at, format: :default)} - #{I18n.l(sch.end_at, format: :timetable)}",
          language: sch.language,
          description: sch.description,
          i18n: {
            speaker: I18n.t('card.detail.speaker'),
            username: I18n.t('card.detail.username'),
            aboutSpeaker: I18n.t('card.detail.about_speaker'),
            startEndTime: I18n.t('card.detail.start_end_time', zone: sch.start_at.zone),
            language: I18n.t('card.detail.language'),
            description: I18n.t('card.detail.description')
          }
        },
        i18n: {
          title: I18n.t('card.detail.title'),
          close: I18n.t('button.close')
        }
      },
      i18n: {
        showDetail: I18n.t('card.show_detail'),
        editMemo: I18n.t('button.update_memo'),
        title: I18n.t('dialog.edit_memo', title: sch.title),
        save: I18n.t('button.save'),
        close: I18n.t('button.close')
      }
    }
    assert_equal expect, schedule_to_card_props(sch, nil, user)
  end

  test 'schedule_to_card_props_with_plan_user_not_own' do
    user = users(:two)
    sch = schedules(:one)
    plan = plans(:one)

    expect = {
      title: sch.title,
      mode: 'list',
      description: sch.description,
      trackName: sch.track_name,
      speakers: sch.speakers.map do |speaker|
        {
          speakerName: speaker.name,
          thumbnailUrl: speaker.thumbnail
        }
      end,
      language: sch.language,
      details: {
        body: {
          speakers: sch.speakers.map do |speaker|
            {
              thumbnailUrl: speaker.thumbnail,
              speaker: speaker.name,
              username: speaker.handle,
              aboutSpeaker: speaker.profile,
              github: speaker.github,
              twitter: speaker.twitter
            }
          end,
          startEndTime: "#{I18n.l(sch.start_at, format: :default)} - #{I18n.l(sch.end_at, format: :timetable)}",
          language: sch.language,
          description: sch.description,
          i18n: {
            speaker: I18n.t('card.detail.speaker'),
            username: I18n.t('card.detail.username'),
            aboutSpeaker: I18n.t('card.detail.about_speaker'),
            startEndTime: I18n.t('card.detail.start_end_time', zone: sch.start_at.zone),
            language: I18n.t('card.detail.language'),
            description: I18n.t('card.detail.description')
          }
        },
        i18n: {
          title: I18n.t('card.detail.title'),
          close: I18n.t('button.close')
        }
      },
      i18n: {
        showDetail: I18n.t('card.show_detail'),
        editMemo: I18n.t('button.update_memo'),
        title: I18n.t('dialog.edit_memo', title: sch.title),
        save: I18n.t('button.save'),
        close: I18n.t('button.close')
      }
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
            { time: '10:00 - 10:40 (UTC)', schedules: [schedule_to_card_props(schs[0], plan, usr), nil],
              sortKey: schs[0].start_at.to_i },
            { time: '11:00 - 11:40 (UTC)', schedules: [nil, schedule_to_card_props(schs[1], plan, usr)],
              sortKey: schs[1].start_at.to_i }
          ]
        },
        '2021-07-21' => {
          trackList: %w[TrackA TrackB TrackC],
          rows: [
            { time: '10:00 - 10:40 (UTC)', schedules: [schedule_to_card_props(schs[2], plan, usr), nil, nil],
              sortKey: schs[2].start_at.to_i },
            { time: '11:00 - 11:40 (UTC)', schedules: [nil] + schs[3..4].map { schedule_to_card_props(_1, plan, usr) },
              sortKey: schs[3].start_at.to_i }
          ]
        }
      },
      initial: {
        title: I18n.t('dialog.terms_of_service'),
        description: I18n.t('terms_of_service.description'),
        termsOfService: I18n.t('terms_of_service.terms_of_service'),
        close: I18n.t('button.close'),
        accept: I18n.t('button.accept_to_add')
      },
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
          { time: '10:00 - 10:40 (UTC)', schedule: schedule_to_card_props(schs[0], plan, user, 'plan'),
            memo: plan.plan_schedules.find_by(schedule: schs[0]).memo, sortKey: schs[0].start_at.to_i },
          { time: '11:00 - 11:40 (UTC)', schedule: schedule_to_card_props(schs[1], plan, user, 'plan'),
            memo: plan.plan_schedules.find_by(schedule: schs[1]).memo, sortKey: schs[1].start_at.to_i }
        ],
        '2021-07-21' => [
          { time: '10:00 - 10:40 (UTC)', schedule: schedule_to_card_props(schs[2], plan, user, 'plan'),
            memo: plan.plan_schedules.find_by(schedule: schs[2]).memo, sortKey: schs[2].start_at.to_i },
          { time: '11:00 - 11:40 (UTC)', schedule: schedule_to_card_props(schs[3], plan, user, 'plan'),
            memo: plan.plan_schedules.find_by(schedule: schs[3]).memo, sortKey: schs[3].start_at.to_i }
        ]
      },
      oopsImagePath: '/2021/rubykaigi.png',
      i18n: {
        startEnd: I18n.t('table.start_end'),
        track: I18n.t('table.track'),
        memo: I18n.t('table.memo'),
        updateMemo: I18n.t('button.update_memo.'),
        noPlans: I18n.t('table.no_plans'),
        noPlansDesc: I18n.t('table.no_plans_description')
      }
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
          { time: '10:00 - 10:40 (UTC)', schedule: schedule_to_card_props(schs[0], plan, user, 'plan'),
            memo: plan.plan_schedules.find_by(schedule: schs[0]).memo, sortKey: schs[0].start_at.to_i },
          { time: '11:00 - 11:40 (UTC)', schedule: schedule_to_card_props(schs[1], plan, user, 'plan'),
            memo: plan.plan_schedules.find_by(schedule: schs[1]).memo, sortKey: schs[1].start_at.to_i }
        ],
        '2021-07-21' => [
          { time: '10:00 - 10:40 (UTC)', schedule: schedule_to_card_props(schs[2], plan, user, 'plan'),
            memo: plan.plan_schedules.find_by(schedule: schs[2]).memo, sortKey: schs[2].start_at.to_i },
          { time: '11:00 - 11:40 (UTC)', schedule: schedule_to_card_props(schs[3], plan, user, 'plan'),
            memo: plan.plan_schedules.find_by(schedule: schs[3]).memo, sortKey: schs[3].start_at.to_i }
        ]
      },
<<<<<<< HEAD
      oopsImagePath: '/2023/rubykaigi.png',
      uri: 'http://test.host/2023/plans/aa67c98c-d81f-5a9c-b0bc-26caa0051aea',
=======
      oopsImagePath: '/2021/rubykaigi.png',
      uri: 'http://test.host/happy-party/plans/aa67c98c-d81f-5a9c-b0bc-26caa0051aea',
>>>>>>> origin/features/event_path
      i18n: {
        startEnd: I18n.t('table.start_end'),
        track: I18n.t('table.track'),
        memo: I18n.t('table.memo'),
        updateMemo: I18n.t('button.update_memo.'),
        noPlans: I18n.t('table.no_plans'),
        noPlansDesc: I18n.t('table.no_plans_description')
      }
    }
    assert_equal expect, create_plan_table_props(plan, user)
  end

  test 'create_info_panel_props' do
    expect = {
      form: {
<<<<<<< HEAD
        action: '/2023/plans',
=======
        action: '/happy-party/plans',
>>>>>>> origin/features/event_path
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
    assert_equal expect, create_info_panel_props(events(:party))
  end
end
