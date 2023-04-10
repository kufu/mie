# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do

  base_event = Event.find_or_initialize_by(name: '2023')
  base_event.build_event_theme if base_event.new_record?
  base_event.save!

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

  Speaker.where.not(id: speakers_by_id.values).destroy_all

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
        next if event['type'] == 'break'

        start_at = Time.zone.parse("#{date} #{event['begin']} JST")
        end_at = Time.zone.parse("#{date} #{event['end']} JST")

        event['talks'].each do |track_name, id|
          schedule = schedules_by_id[id]

          schedule.update!(
            track_name: "Track#{track_name}",
            start_at: start_at,
            end_at: end_at,
            event: base_event
          )
        end
      end
    end
  else
    schedules_by_id = schedule_yaml.each_with_object({}) do |(date, schedules), hash|
      schedules['events'].each do |event|
        next if event['type'] == 'break'

        start_at = Time.zone.parse("#{date} #{event['begin']} JST")
        end_at = Time.zone.parse("#{date} #{event['end']} JST")

        event['talks'].each do |track_name, id|
          hash[id] = Schedule.find_or_initialize_by(
            track_name: "Track#{track_name}",
            start_at: start_at,
            end_at: end_at,
            event: base_event
          )
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
