namespace :plans do
  desc "Extract plans with timeline by ID"
  task :csv, ['id'] => :environment do |task, args|
    Time.use_zone('Asia/Tokyo') do
      helper = Class.new do
        include ReactHelper
        include SchedulesHelper

        def form_authenticity_token(*) = ''
      end.new

      table_array = helper.create_table_array(Schedule.all)

      plan = Plan.find(args[:id])
      list =  helper.create_schedule_table_props(table_array, plan, plan.user)

      res = list[:groupedSchedules].map do |key, table|
        planned_list = table[:rows].map do |row|
          target = row[:schedules].find do |s|
            s&.dig(:form, :targetKeyName)&.start_with?("remove")
          end
          [row[:time], target ? target[:id] : '']
        end
        [key, planned_list]
      end

      res.each do |k, v|
        puts "#{k},"
        v.each { puts "#{_1[0]},#{_1[1]}"}
      end

    end
  end
end
