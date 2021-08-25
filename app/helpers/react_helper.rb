# frozen_string_literal: true

module ReactHelper
  include HelperConcern

  def schedule_to_card_props(schedule, plan, user, mode = 'list')
    props = {
      title: schedule.title,
      mode: mode,
      description: schedule.description,
      speakerName: schedule.speaker.name,
      thumbnailUrl: schedule.speaker.thumbnail,
      language: schedule.language,
      details: create_schedule_detail_props(schedule),
      i18n: {
        showDetail: I18n.t('card.show_detail'),
        editMemo: I18n.t('button.update_memo'),
        title: I18n.t('dialog.edit_memo', title: schedule.title),
        save: I18n.t('button.save'),
        close: I18n.t('button.close')
      }
    }

    props[:memo] = plan.plan_schedules.find_by(schedule: schedule).memo || '' if plan&.schedules&.include?(schedule)

    if plan && plan.user == user
      include_plan = plan.schedules.include?(schedule)
      method = 'patch'
      action = plan_path(plan)

      props[:form] = {
        action: action,
        method: method,
        authenticityToken: form_authenticity_token(form_options: { action: action, method: method }),
        targetKeyName: include_plan ? 'remove_schedule_id' : 'add_schedule_id',
        targetKey: schedule.id,
        buttonText: I18n.t('card.add'),
        i18n: {
          added: plan.schedules.include?(schedule) ? I18n.t('card.added') : nil
        }
      }
    end

    props
  end

  def create_schedule_detail_props(schedule)
    speaker = schedule.speaker
    {
      body: {
        thumbnailUrl: speaker.thumbnail,
        speaker: speaker.name,
        username: speaker.handle,
        aboutSpeaker: speaker.profile,
        github: speaker.github,
        twitter: speaker.twitter,
        startTime: I18n.l(schedule.start_at, format: :timetable),
        endTime: I18n.l(schedule.end_at, format: :timetable),
        language: schedule.language,
        description: schedule.description,
        i18n: {
          speaker: I18n.t('card.detail.speaker'),
          username: I18n.t('card.detail.username'),
          aboutSpeaker: I18n.t('card.detail.about_speaker'),
          startTime: I18n.t('card.detail.start_time', zone: schedule.start_at.zone),
          endTime: I18n.t('card.detail.end_time', zone: schedule.start_at.zone),
          language: I18n.t('card.detail.language'),
          description: I18n.t('card.detail.description')
        }
      },
      i18n: {
        title: I18n.t('card.detail.title'),
        close: I18n.t('button.close')
      }
    }
  end

  def create_schedule_table_props(table_array, plan, user)
    props = {}
    props[:groupedSchedules] = schedule_table_props(table_array, plan, user)
    props[:i18n] = schedule_table_i18n
    props
  end

  def create_plan_table_props(plan, user)
    props = {}

    props[:groupedPlans] = plans_table_props(plan, user)
    props[:i18n] = plans_table_i18n
    props
  end

  def create_plan_description_props(plan)
    props = {}
    props[:description] = plan.description
    props[:i18n] = plan_description_i18n

    method = 'patch'
    action = plan_path(plan)
    props[:form] = {
      action: action,
      method: method,
      authenticityToken: form_authenticity_token(form_options: { action: action, method: method }),
      i18n: plan_description_form_i18n
    }

    props
  end

  def create_locale_selector_props
    props = {}
    props[:current] = session[:locale] if session[:locale]
    props[:options] = grouped_timezones.map do |k, v|
      {
        label: k,
        options: v.map { |zone| { label: zone, value: zone } }
      }
    end
    props[:i18n] = {
      label: I18n.t('nav.select_locale')
    }

    props
  end

  def create_navigation_props
    {
      current: request.path.split('/')[2],
      rootLink: '/2021',
      schedulesLink: schedules_path,
      plansLink: @user.plans&.first ? plan_path(@user.plans&.first) : nil,
      locales: create_locale_selector_props,
      i18n: navigation_i18n
    }
  end

  def create_plan_title_props(plan)
    props = {
      title: plan.title,
      visible: plan.public?,
      i18n: {
        edit: I18n.t('button.edit')
      }
    }

    method = 'patch'
    action = plan_path(plan)
    props[:form] = {
      action: action,
      method: method,
      authenticityToken: form_authenticity_token(form_options: { action: action, method: method }),
      i18n: {
        title: I18n.t('dialog.edit_title'),
        save: I18n.t('button.save'),
        close: I18n.t('button.close')
      }
    }
    props
  end

  def create_info_panel_props
    action = plans_path
    {
      form: {
        action: action,
        authenticityToken: form_authenticity_token(form_options: { action: action, method: 'post' })
      },
      i18n: info_panel_i18n
    }
  end

  def create_setting_button_props(plan)
    props = {}
    props[:visible] = plan.public
    props[:i18n] = setting_button_i18n

    method = 'patch'
    action = plan_path(plan)

    props[:form] = {
      action: action,
      method: method,
      authenticityToken: form_authenticity_token(form_options: { action: action, method: method }),
      i18n: setting_button_form_i18n
    }
    props
  end

  private

  def schedule_table_props(table_array, plan, user)
    props = table_array.map do |k, v|
      track_list = v.first.compact
      rows = v[1..].map do |s|
        { time: s.first, schedules: s[1..].map { |sc| sc.nil? ? sc : schedule_to_card_props(sc, plan, user) } }
      end
      [k, { trackList: track_list, rows: rows }]
    end

    props.to_h
  end

  def schedule_table_i18n
    { startEnd: I18n.t('table.start_end') }
  end

  def plans_table_props(plan, user)
    props = group_schedules_by_date(plan.schedules).map do |k, v|
      rows = group_schedules_by_time(v).map do |time, schedules|
        {
          time: time,
          schedule: schedule_to_card_props(schedules.first, plan, user, 'plan'),
          memo: plan.plan_schedules.find_by(schedule: schedules.first)&.memo
        }
      end
      [k, rows]
    end

    props.to_h
  end

  def plans_table_i18n
    {
      startEnd: I18n.t('table.start_end'),
      track: I18n.t('table.track'),
      memo: I18n.t('table.memo'),
      updateMemo: I18n.t('button.update_memo')
    }
  end

  def plan_description_i18n
    {
      title: I18n.t('description.title'),
      notice: I18n.t('description.notice'),
      button: I18n.t('button.edit')
    }
  end

  def plan_description_form_i18n
    {
      title: I18n.t('description.form_titme'),
      save: I18n.t('button.save'),
      close: I18n.t('button.close')
    }
  end

  def navigation_i18n
    {
      rootButton: I18n.t('nav.root'),
      scheduleButton: I18n.t('nav.schedule'),
      plansButton: I18n.t('nav.plan'),
      help: I18n.t('nav.help')
    }
  end

  def info_panel_i18n
    {
      title: I18n.t('info.create_plan_title'),
      openText: I18n.t('button.open_text'),
      closeText: I18n.t('button.close_text'),
      information: I18n.t('info.create_plan_text'),
      termsOfService: I18n.t('info.terms_of_service'),
      buttonText: I18n.t('button.plan_create_button')
    }
  end

  def setting_button_i18n
    {
      settings: I18n.t('button.settings'),
      changeVisibility: I18n.t('settings.change_visibility'),
      visibilityDesc: I18n.t('settings.visibility_description'),
      setPassword: I18n.t('settings.set_password'),
      visibleText: I18n.t('settings.visible_text'),
      visibleDesc: I18n.t('settings.visible_description'),
      invisibleText: I18n.t('settings.invisible_text'),
      invisibleDesc: I18n.t('settings.invisible_description')
    }
  end

  def setting_button_form_i18n
    {
      title: I18n.t('settings.title'),
      save: I18n.t('button.save'),
      close: I18n.t('button.close')
    }
  end
end
