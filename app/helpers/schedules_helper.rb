# frozen_string_literal: true

module SchedulesHelper
  def toggle_script(date, dates)
    [show_script(date), dates.reject { |d| d == date }.map { |d| hide_script(d) }].flatten.join(';')
  end

  private


  def hide_script(date)
    %(document.getElementById("#{date}").style.display = "none";)
  end

  def show_script(date)
    %(document.getElementById("#{date}").style.display = "block";)
  end
end
