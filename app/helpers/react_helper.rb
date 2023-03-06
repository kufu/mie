# frozen_string_literal: true

module ReactHelper
  include HelperConcern

  def schedule_to_card_props(schedule, plan, user, mode = 'list')
    props = {
      title: schedule.title,
      mode:,
      description: schedule.description,
      trackName: schedule.track_name,
      speakers: schedule.speakers.map do |speaker|
        {
          speakerName: speaker.name,
          thumbnailUrl: speaker.thumbnail
        }
      end,
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

    props.merge!(plan_edit_props(plan, schedule, mode)) if plan && plan.user == user

    props
  end

  def create_schedule_detail_props(schedule)
    {
      body: {
        speakers: schedule.speakers.map do |speaker|
          {
            thumbnailUrl: speaker.thumbnail,
            speaker: speaker.name,
            username: speaker.handle,
            aboutSpeaker: speaker.profile,
            github: speaker.github,
            twitter: speaker.twitter
          }
        end,
        startEndTime: "#{I18n.l(schedule.start_at, format: :default)} - #{I18n.l(schedule.end_at, format: :timetable)}",
        language: schedule.language,
        description: schedule.description,
        i18n: {
          speaker: I18n.t('card.detail.speaker'),
          username: I18n.t('card.detail.username'),
          aboutSpeaker: I18n.t('card.detail.about_speaker'),
          startEndTime: I18n.t('card.detail.start_end_time', zone: schedule.start_at.zone),
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
    props[:initial] = terms_of_service_props if plan.initial?
    props[:i18n] = schedule_table_i18n
    props
  end

  def create_plan_table_props(plan, user)
    props = {}

    props[:groupedPlans] = plans_table_props(plan, user)
    props[:oopsImagePath] = asset_path('2023/rubykaigi.png')
    props[:uri] = url_for([plan, { only_path: false }])
    props[:i18n] = plans_table_i18n
    props
  end

  def create_plan_description_props(plan, user)
    props = {}
    props[:description] = plan.description
    props[:maxLength] = Plan.validators_on(:description).detect do |v|
                          v.is_a?(ActiveModel::Validations::LengthValidator)
                        end.options[:maximum]
    props[:i18n] = plan_description_i18n

    if user.plans.include?(plan)
      method = 'patch'
      action = plan_path(plan)
      props[:form] = {
        action:,
        method:,
        authenticityToken: form_authenticity_token(form_options: { action:, method: }),
        i18n: plan_description_form_i18n
      }
    end

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
      rootLink: '/2023',
      schedulesLink: schedules_path,
      plansLink: @plan ? plan_path(@plan) : nil,
      locales: create_locale_selector_props,
      i18n: navigation_i18n
    }
  end

  def create_plan_title_props(plan, user)
    props = {
      title: plan.title,
      maxLength: Plan.validators_on(:title).detect do |v|
                   v.is_a?(ActiveModel::Validations::LengthValidator)
                 end.options[:maximum],
      visible: plan.public?,
      i18n: {
        label: I18n.t(plan.public? ? 'settings.visible' : 'settings.invisible'),
        edit: I18n.t('button.edit')
      }
    }

    if user.plans.include?(plan)
      method = 'patch'
      action = plan_path(plan)
      props[:form] = {
        action:,
        method:,
        authenticityToken: form_authenticity_token(form_options: { action:, method: }),
        i18n: {
          title: I18n.t('dialog.edit_title'),
          save: I18n.t('button.save'),
          close: I18n.t('button.close')
        }
      }
    end

    props
  end

  def create_info_panel_props
    action = plans_path
    {
      form: {
        action:,
        authenticityToken: form_authenticity_token(form_options: { action:, method: 'post' })
      },
      i18n: info_panel_i18n
    }
  end

  def create_setting_button_props(plan)
    props = {}
    props[:visible] = plan.public
    props[:i18n] = setting_button_i18n(plan.public)

    method = 'patch'
    action = plan_path(plan)

    props[:form] = {
      action:,
      method:,
      authenticityToken: form_authenticity_token(form_options: { action:, method: }),
      i18n: setting_button_form_i18n
    }
    props
  end

  def create_make_editable_button_props(plan)
    props = {}
    props[:i18n] = {
      makeEditable: I18n.t('button.make_editable')
    }

    method = 'patch'
    action = plan_own_path(plan)

    props[:form] = {
      action:,
      method:,
      authenticityToken: form_authenticity_token(form_options: { action:, method: }),
      i18n: make_editable_button_form_i18n
    }
    props
  end

  def create_not_found_props
    {
      title: I18n.t('errors.not_found'),
      description: I18n.t('errors.not_found_desc'),
      imagePath: asset_path('2023/rubykaigi.png')
    }
  end

  def create_server_error_props
    {
      title: I18n.t('errors.internal_server_error'),
      imagePath: asset_path('2023/rubykaigi.png')
    }
  end

  def create_top_props
    {
      intro: I18n.t('application.intro')
    }
  end

  private

  def schedule_table_props(table_array, plan, user)
    props = table_array.map do |k, v|
      track_list = v.first.compact
      rows = v[1..].map do |s|
        sort_keys = s[1..].compact.map(&:start_at).map(&:to_i).uniq
        { time: s.first,
          schedules: s[1..].map { |sc| sc.nil? ? sc : schedule_to_card_props(sc, plan, user) },
          sortKey: sort_keys[0] }
      end
      [k, { trackList: track_list, rows: rows.sort_by { |r| r[:sortKey] } }]
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
          time:,
          schedule: schedule_to_card_props(schedules.first, plan, user, 'plan'),
          memo: plan.plan_schedules.find_by(schedule: schedules.first)&.memo,
          sortKey: schedules.first.start_at.to_i
        }
      end
      [k, rows.sort_by { |r| r[:sortKey] }]
    end

    props.to_h
  end

  def plan_edit_props(plan, schedule, mode)
    props = {}
    method = 'patch'
    action = plan_path(plan)

    include_plan = plan.plan_schedules.find { |ps| ps.schedule == schedule }
    props[:memo] = include_plan&.memo || ''
    props[:memoMaxLength] = PlanSchedule.validators_on(:memo).detect do |v|
      v.is_a?(ActiveModel::Validations::LengthValidator)
    end.options[:maximum]

    i18n = {
      added: include_plan ? I18n.t('card.added') : nil
    }

    props[:form] = {
      method:,
      action:,
      authenticityToken: form_authenticity_token(form_options: { action:, method: }),
      targetKeyName: include_plan ? 'remove_schedule_id' : 'add_schedule_id',
      targetKey: schedule.id,
      buttonText: include_plan ? I18n.t('card.remove') : I18n.t('card.add'),
      mode:,
      i18n:
    }

    props
  end

  def plans_table_i18n
    {
      startEnd: I18n.t('table.start_end'),
      track: I18n.t('table.track'),
      memo: I18n.t('table.memo'),
      updateMemo: I18n.t('button.update_memo'),
      noPlans: I18n.t('table.no_plans'),
      noPlansDesc: I18n.t('table.no_plans_description')
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

  def terms_of_service_props
    {
      title: I18n.t('dialog.terms_of_service'),
      description: I18n.t('terms_of_service.description'),
      termsOfService: I18n.t('terms_of_service.terms_of_service'),
      close: I18n.t('button.close'),
      accept: I18n.t('button.accept_to_add')
    }
  end

  def setting_button_i18n(visibility)
    {
      settings: I18n.t('button.settings'),
      changeVisibility: I18n.t('settings.change_visibility'),
      visibilityDesc: I18n.t('settings.visibility_description',
                             current: I18n.t(visibility ? 'settings.visible' : 'settings.invisible')),
      setPassword: I18n.t('settings.set_password'),
      passwordExpression: I18n.t('settings.password_expression'),
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

  def make_editable_button_form_i18n
    {
      title: I18n.t('button.make_editable'),
      takeOwn: I18n.t('button.check_password'),
      close: I18n.t('button.close'),
      inputPassword: I18n.t('dialog.input_password')
    }
  end
end
