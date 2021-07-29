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
    schedule_table_props = table_array.map do |k, v|
      track_list = v.first.compact
      rows = v[1..].map do |s|
        { time: s.first, schedules: s[1..].map { |sc| sc.nil? ? sc : schedule_to_card_props(sc, plan) } }
      end
      [k, { trackList: track_list, rows: rows }]
    end

    schedule_table_props.to_h
  end

  def create_plan_table_props(plan)
    props = group_schedules_by_date(plan.schedules).map do |k, v|
      rows = group_schedules_by_time(v).map do |time, schedules|
        { time: time, schedule: schedule_to_card_props(schedules.first, plan) }
      end
      [k, rows]
    end

    props.to_h
  end
end
