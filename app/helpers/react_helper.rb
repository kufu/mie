# frozen_string_literal: true

module ReactHelper
  def schedule_to_card_props(schedule)
    {
      title: schedule.title,
      description: schedule.description,
      speakerName: schedule.speaker.name,
      thumbnailUrl: schedule.speaker.thumbnail,
      language: schedule.language
    }
  end

  def create_schedule_table_props(table_array)
    schedule_table_props = table_array.map do |k, v|
      track_list = v.first.compact
      rows = v[1..].map do |s|
        { time: s.first, schedules: s[1..].map { |sc| sc.nil? ? sc : schedule_to_card_props(sc) } }
      end
      [k, { trackList: track_list, rows: rows }]
    end

    schedule_table_props.to_h
  end
end
