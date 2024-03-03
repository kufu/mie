# frozen_string_literal: true

module ApplicationHelper
  def current_path?(path)
    request.path == path
  end

  # time_str: 「01:15 - 01:40 (UTC)」みたいな文字列を想定
  def split_time_and_zone(time_str)
    time_str.match(/^(.+?)\s\((.+?)\)$/).then { { range: _1[1], zone: _1[2] } }
  end

  def card_button_turbo_frame_option(mode, event, schedule)
    return schedule_card_button_turbo_frame_option(mode, event, schedule) if mode == :schedule
    return plan_card_button_turbo_frame_option(mode, event, schedule) if mode == :plan

    {}
  end
end
