# frozen_string_literal: true

module SchedulesHelper
  include HelperConcern

  def create_table_array(schedules)
    group_schedules_by_date(schedules).to_h do |k, v|
      tracks = v.map(&:track_name).uniq.sort { |l, r| l.reverse <=> r.reverse } # TODO: 2023用超その場しのぎ実装、今すぐどうにかしてほしい
      arrays = group_schedules_by_time(v).map { |time, s| [time] + track_mapping_schedules(tracks, s) }
      arrays.unshift([nil, tracks].flatten)
      [k, arrays]
    end
  end

  def toggle_script(date, dates)
    [show_script(date), dates.reject { |d| d == date }.map { |d| hide_script(d) }].flatten.join(';')
  end

  private

  def track_mapping_schedules(tracks, schedules)
    tracks.map { |t| schedules.find { |s| s.track_name == t } }
  end

  def hide_script(date)
    %(document.getElementById("#{date}").style.display = "none";)
  end

  def show_script(date)
    %(document.getElementById("#{date}").style.display = "block";)
  end
end
