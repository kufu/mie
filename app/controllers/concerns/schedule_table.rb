# frozen_string_literal: true

module ScheduleTable
  extend ActiveSupport::Concern

  DATE_FORMAT = '%Y-%m-%d'

  def schedule_table(table_array)
    props = table_array.map do |k, v|
      track_list = v.first.compact
      rows = v[1..].map do |s|
        sort_keys = s[1..].compact.map(&:start_at).map(&:to_i).uniq
        { time: split_time_and_zone(s.first),
          schedules: s[1..],
          sort_key: sort_keys[0] }
      end
      [k, { track_list:, rows: rows.sort_by { |r| r[:sort_key] } }]
    end

    props.to_h
  end

  def plans_table(plan)
    props = group_schedules_by_date(plan.schedules).map do |k, v|
      rows = group_schedules_by_time(v).map do |time, schedules|
        {
          time: split_time_and_zone(time),
          schedule: schedules.first,
          memo: plan.plan_schedules.find_by(schedule: schedules.first)&.memo,
          sortKey: schedules.first.start_at.to_i
        }
      end
      [k, rows.sort_by { |r| r[:sortKey] }]
    end

    props.to_h
  end

  private

  def schedule_track_row(schedule)
    schedule.start_at.strftime(DATE_FORMAT)
  end

  def group_schedules_by_date(schedules)
    schedules.group_by { schedule_track_row(_1) }
  end

  def track_mapping_schedules(tracks, schedules)
    tracks.map { |t| schedules.find { |s| s.track_name == t } }
  end

  def group_schedules_by_time(schedules)
    schedules.group_by do |s|
      start_at = I18n.l(s.start_at, format: :timetable)
      end_at = I18n.l(s.end_at, format: :timetable)
      zone = s.end_at.strftime('%Z')

      "#{start_at} - #{end_at} (#{zone})"
    end
  end

  def create_table_array(schedules)
    group_schedules_by_date(schedules).to_h do |k, v|
      tracks = v.map(&:track_name).uniq.sort { |l, r| l.reverse <=> r.reverse } # TODO: 2023用超その場しのぎ実装、今すぐどうにかしてほしい
      arrays = group_schedules_by_time(v).map { |time, s| [time] + track_mapping_schedules(tracks, s) }
      arrays.unshift([nil, tracks].flatten)
      [k, arrays]
    end
  end

  # time_str: 「01:15 - 01:40 (UTC)」みたいな文字列を想定
  def split_time_and_zone(time_str)
    time_str.match(/^(.+?)\s\((.+?)\)$/).then { { range: _1[1], zone: _1[2] } }
  end
end
