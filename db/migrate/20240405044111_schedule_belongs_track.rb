class ScheduleBelongsTrack < ActiveRecord::Migration[7.1]
  def up
    remove_column :schedules, :event_id
  end

  def down
    add_column :schedules, :event_id, :uuid

    Schedule.all.each do |schedule|
      schedule.update!(event: schedule.track.event)
    end

    change_column :schedules, :event_id, :uuid, null: false
  end
end
