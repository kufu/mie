# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  speaker_1 = Speaker.create!(name: 'John Wick', handle: 'boogie man',
                              thumbnail: 'https://i.insider.com/543e6a5369bedd0f5b7e846f?width=700', profile: 'I love dog', language: :en)
  speaker_2 = Speaker.create!(name: 'Johnny Silverhand', handle: 'rockerboy',
                              thumbnail: 'https://www.sideshow.com/wp/wp-content/uploads/2019/12/Cyberpunk-Keanu.jpg', profile: "Chippin' in", language: :ja)

  schedule_1 = Schedule.create!(title: 'Hotel Contilental', description: 'TBD',
                                start_at: Time.zone.parse('2021-09-12 12:00:00'), end_at: Time.zone.parse('2021-09-12 12:40:00'), speaker: speaker_1)
  schedule_2 = Schedule.create!(title: 'How to quit the job', description: 'TBD',
                                start_at: Time.zone.parse('2021-09-13 12:00:00'), end_at: Time.zone.parse('2021-09-13 12:00:00'), speaker: speaker_1)
  schedule_3 = Schedule.create!(title: 'Anti ARASAKA', description: '',
                                start_at: Time.zone.parse('2021-09-12 12:30:00'), end_at: Time.zone.parse('2021-09-12 13:10:00'), speaker: speaker_2)
  schedule_4 = Schedule.create!(title: 'V', description: 'TBD', start_at: Time.zone.parse('2021-09-14 12:00:00'),
                                end_at: Time.zone.parse('2021-09-14 12:40:00'), speaker: speaker_2)

  user = User.create!

  plan = Plan.create!(user: user, title: 'My favorite lineup', schedules: [schedule_1, schedule_2, schedule_4])
end
