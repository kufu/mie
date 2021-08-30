# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  speakers_yaml = {}.merge(*YAML.load_file('db/seeds/speakers.yml').values)

  speakers_by_id = speakers_yaml.transform_values do |val|
    speaker = Speaker.find_or_initialize_by(handle: "@#{val['id']}")
    speaker.save!(
      name: val['name'],
      thumbnail: "https://www.gravatar.com/avatar/#{val['gravatar_hash']}/?s=268&d=https%3A%2F%2Frubykaigi.org%2F2020%2Fimages%2Fspeakers%2Fdummy-avatar.png",
      profile: val['bio'],
      github: val['github_id'],
      twitter: val['twitter_id']
    )
    speaker
  end

  Speaker.where.not(handle: speakers_yaml.map { |_, val| "@#{val['id']}" }).destroy_all

  schedule_yaml = YAML.load_file('db/seeds/schedule.yml')
  schedules_by_id = schedule_yaml.each_with_object({}) do |(date, schedules), hash|
    schedules['events'].each do |event|
      next if event['type'] == 'break'

      start_at = Time.zone.parse("#{date} #{event['begin']} JST")
      end_at = Time.zone.parse("#{date} #{event['end']} JST")

      event['talks'].each do |track_name, id|
        hash[id] = Schedule.find_or_initialize_by(
          track_name: "Track#{track_name}",
          start_at: start_at,
          end_at: end_at
        )
      end
    end
  end

  # NOTE: ScheduleSpeakerは一度破棄して作り直す
  ScheduleSpeaker.delete_all
  YAML.load_file('db/seeds/presentations.yml').each do |id, presentation|
    schedule = schedules_by_id[id]

    schedule.save!(
      title: presentation['title'],
      description: presentation['description'],
      language: presentation['language'].downcase
    )

    presentation['speakers'].each do |speakers|
      ScheduleSpeaker.create!(schedule: schedule, speaker: speakers_by_id[speakers['id']])
    end
  end
end
