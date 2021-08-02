# frozen_string_literal: true

module ReactHelper
  include HelperConcern

  def schedule_to_card_props(schedule, plan)
    include_plan = plan.schedules.include?(schedule)
    method = 'patch'
    action = plan_path(plan)

    {
      title: schedule.title,
      description: schedule.description,
      speakerName: schedule.speaker.name,
      thumbnailUrl: schedule.speaker.thumbnail,
      language: schedule.language,
      action: action,
      method: method,
      authenticityToken: form_authenticity_token(form_options: { action: action, method: method }),
      targetKeyName: include_plan ? 'remove_schedule_id' : 'add_schedule_id',
      targetKey: schedule.id,
      buttonText: include_plan ? 'remove' : 'add'
    }
  end

  def create_schedule_table_props(table_array, plan)
    props = {}
    props[:groupedSchedules] = schedule_table_props(table_array, plan)
    props[:current] = props[:groupedSchedules].keys.first
    props[:i18n] = schedule_table_i18n
    props
  end

  def create_plan_table_props(plan)
    props = {}

    props[:groupedPlans] = plans_table_props(plan)
    props[:current] = props[:groupedPlans].keys.first
    props[:i18n] = plans_table_i18n
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
      current: request.path.split('/')[1],
      schedulesLink: schedules_path,
      plansLink: plan_path(@user.plans&.first),
      locales: create_locale_selector_props,
      i18n: navigation_i18n
    }
  end

  private

  def schedule_table_props(table_array, plan)
    props = table_array.map do |k, v|
      track_list = v.first.compact
      rows = v[1..].map do |s|
        { time: s.first, schedules: s[1..].map { |sc| sc.nil? ? sc : schedule_to_card_props(sc, plan) } }
      end
      [k, { trackList: track_list, rows: rows }]
    end

    props.to_h
  end

  def schedule_table_i18n
    { startEnd: I18n.t('table.start_end') }
  end

  def plans_table_props(plan)
    props = group_schedules_by_date(plan.schedules).map do |k, v|
      rows = group_schedules_by_time(v).map do |time, schedules|
        {
          time: time,
          schedule: schedule_to_card_props(schedules.first, plan),
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

  def navigation_i18n
    {
      label: I18n.t('nav.label'),
      scheduleButton: I18n.t('nav.schedule'),
      plansButton: I18n.t('nav.plan'),
      help: I18n.t('nav.help')
    }
  end
end
