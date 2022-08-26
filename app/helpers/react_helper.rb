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
      details: create_schedule_detail_props(schedule)
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
        timezone: Time.zone.tzinfo.abbr,
        language: schedule.language,
        description: schedule.description,
      },
    }
  end

  def create_schedule_table_props(table_array, plan, user)
    props = {}
    props[:groupedSchedules] = schedule_table_props(table_array, plan, user)
    props[:initial] = terms_of_service_props if plan.initial?
    props
  end

  def create_plan_table_props(plan, user)
    props = {}

    props[:groupedPlans] = plans_table_props(plan, user)
    props[:oopsImagePath] = asset_path('2021/rubykaigi.png')
    props[:uri] = @plan_uri
    props
  end

  def create_plan_description_props(plan, user)
    props = {}
    props[:description] = plan.description
    props[:maxLength] = Plan.validators_on(:description).detect do |v|
                          v.is_a?(ActiveModel::Validations::LengthValidator)
                        end.options[:maximum]

    if user.plans.include?(plan)
      method = 'patch'
      action = plan.id
      props[:form] = {
        action:,
        method:,
        authenticityToken: form_authenticity_token(form_options: { action:, method: }),
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

    props
  end

  def create_navigation_props
    {
      current: request.path.split('/')[2],
      rootLink: '/2022',
      schedulesLink: '/2022/schedules',
      plansLink: @plan ? "/2022/plans/#{@plan.id}" : nil,
      locales: create_locale_selector_props,
    }
  end

  def create_plan_title_props(plan, user)
    props = {
      title: plan.title,
      maxLength: Plan.validators_on(:title).detect do |v|
                   v.is_a?(ActiveModel::Validations::LengthValidator)
                 end.options[:maximum],
      visible: plan.public?,
    }

    if user.plans.include?(plan)
      method = 'patch'
      action = plan.id
      props[:form] = {
        action:,
        method:,
        authenticityToken: form_authenticity_token(form_options: { action:, method: }),
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
    }
  end

  def create_setting_button_props(plan)
    props = {}
    props[:visible] = plan.public

    method = 'patch'
    action = plan.id

    props[:form] = {
      action:,
      method:,
      authenticityToken: form_authenticity_token(form_options: { action:, method: }),
    }
    props
  end

  def create_make_editable_button_props(plan)
    props = {}

    method = 'patch'
    action = plan.id

    props[:form] = {
      action:,
      method:,
      authenticityToken: form_authenticity_token(form_options: { action:, method: }),
    }
    props
  end

  def create_not_found_props
    {
      title: I18n.t('errors.not_found'),
      description: I18n.t('errors.not_found_desc'),
      imagePath: asset_path('2021/rubykaigi.png')
    }
  end

  def create_server_error_props
    {
      title: I18n.t('errors.internal_server_error'),
      imagePath: asset_path('2021/rubykaigi.png')
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
    action = plan.id

    include_plan = plan.plan_schedules.find { |ps| ps.schedule == schedule }
    props[:memo] = include_plan&.memo || ''
    props[:memoMaxLength] = PlanSchedule.validators_on(:memo).detect do |v|
      v.is_a?(ActiveModel::Validations::LengthValidator)
    end.options[:maximum]

    props[:form] = {
      method:,
      action:,
      authenticityToken: form_authenticity_token(form_options: { action:, method: }),
      targetKeyName: include_plan ? 'remove_schedule_id' : 'add_schedule_id',
      targetKey: schedule.id,
      mode:,
    }
    props[:form][:termsOfService] = terms_of_service_props[:termsOfService] if plan.initial?

    props
  end

  def terms_of_service_props
    {
      termsOfService: I18n.t('terms_of_service.terms_of_service'),
    }
  end
end
