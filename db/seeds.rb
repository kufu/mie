# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do

  base_event = Event.find_or_initialize_by(name: '2025')
  base_event.build_event_theme(
    main_color: "#FF5719",
    sub_color: "#FFF5EC",
    accent_color: "#FF5719",
    text_color: "#000000"
  ) if base_event.new_record?
  base_event.save!
  base_event.reload

  speakers_yaml = {}.merge(*YAML.load_file('db/seeds/speakers.yml').values)

  speakers_by_id = speakers_yaml.transform_values do |val|
    speaker = Speaker.find_or_initialize_by(handle: "@#{val['id']}", event: base_event)
    speaker.update!(
      name: val['name'],
      thumbnail: "https://www.gravatar.com/avatar/#{val['gravatar_hash']}/?s=268&d=https%3A%2F%2Frubykaigi.org%2F2020%2Fimages%2Fspeakers%2Fdummy-avatar.png",
      profile: val['bio'],
      github: val['github_id'],
      twitter: val['twitter_id']
    )
    speaker
  end

  Speaker.where.not(id: speakers_by_id.values).where.not(event: base_event).destroy_all

  schedule_yaml = YAML.load_file('db/seeds/schedule.yml')
  presentation_yaml = YAML.load_file('db/seeds/presentations.yml')

  if ENV['SCHEDULE_FIND_BY'] == 'title'
    schedules_by_id = presentation_yaml.transform_values do |val|
      schedule = Schedule.find_or_initialize_by(title: val['title'], event: base_event)
      schedule.attributes = {
        description: val['description'],
        language: val['language'].downcase
      }
      schedule
    end

    schedule_yaml.each do |date, schedules|
      schedules['events'].each do |event|
        start_at = Time.zone.parse("#{date} #{event['begin']} JST")
        end_at = Time.zone.parse("#{date} #{event['end']} JST")

        case event['type']
        when 'break'
          next
        when 'lt'
          next # LTのデータが埋まったら対応する
        else
          event['talks'].each do |track_name, id| schedule = schedules_by_id[id]
          track = Track.find_or_create_by!(event: base_event, name: track_name)
          schedule.update!(
            track: track,
            start_at: start_at,
            end_at: end_at
          )
          end
        end
      end
    end
  else
    schedules_by_id = schedule_yaml.each_with_object({}) do |(date, schedules), hash|
      schedules['events'].each do |event|
        start_at = Time.zone.parse("#{date} #{event['begin']} JST")
        end_at = Time.zone.parse("#{date} #{event['end']} JST")

        case event['type']
        when 'break'
          next
        when 'lt'
          track = Track.find_or_create_by!(event: base_event, name: "Large Hall")
          Schedule.find_or_create_by!(
            track: track,
            start_at: start_at,
            end_at: end_at,
            title: event['name'],
            description: event['name'],
            language: 'en & ja'
          )
        else
          event['talks'].each do |track_name, id|
            track = Track.find_or_create_by!(event: base_event, name: track_name)
            hash[id] = Schedule.find_or_initialize_by(
              track: track,
              start_at: start_at,
              end_at: end_at
            )
          end
        end
      end
    end

    presentation_yaml.each do |id, presentation|
      schedule = schedules_by_id[id]

      schedule.update!(
        title: presentation['title'],
        description: presentation['description'],
        language: presentation['language'].downcase
      )
    end
  end

  # NOTE: ScheduleSpeakerは一度破棄して作り直す
  ScheduleSpeaker.delete_all

  presentation_yaml.each do |id, presentation|
    presentation['speakers'].each do |speakers|
      ScheduleSpeaker.create!(schedule: schedules_by_id[id], speaker: speakers_by_id[speakers['id']])
    end
  end
end
