# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  Speaker.delete_all
  Schedule.delete_all

  speakers_by_id = {}.merge(*YAML.load_file('db/seeds/speakers.yml').values).transform_values do |val|
    Speaker.create!(
      name: val['name'],
      handle: "@#{val['id']}",
      thumbnail: "https://www.gravatar.com/avatar/#{val['gravatar_hash']}/?s=268&d=https%3A%2F%2Frubykaigi.org%2F2020%2Fimages%2Fspeakers%2Fdummy-avatar.png",
      profile: val['bio'],
      github: val['github_id'],
      twitter: val['twitter_id']
    )
  end

  schedules_by_id = YAML.load_file('db/seeds/schedule.yml').each_with_object({}) do |(date, schedules), hash|
    schedules['events'].each do |event|
      next if event['type'] == 'break'

      start_at = Time.zone.parse("#{date} #{event['begin']} JST")
      end_at = Time.zone.parse("#{date} #{event['end']} JST")

      event['talks'].each do |track_name, id|
        hash[id] = Schedule.new(
          track_name: "Track#{track_name}",
          start_at: start_at,
          end_at: end_at
        )
      end
    end
  end

  YAML.load_file('db/seeds/presentations.yml').each do |id, presentation|
    schedule = schedules_by_id[id]

    schedule.update!(
      title: presentation['title'],
      description: presentation['description'],
      language: presentation['language'].downcase
    )

    presentation['speakers'].each do |speakers|
      ScheduleSpeaker.create!(schedule: schedule, speaker: speakers_by_id[speakers['id']])
    end
  end
end
