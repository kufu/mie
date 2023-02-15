class AddReferencesToEvents < ActiveRecord::Migration[6.1]
  def up
    add_column :plans, :event_id, :uuid, foreign_key: true
    add_column :schedules, :event_id, :uuid, foreign_key: true
    add_column :speakers, :event_id, :uuid, foreign_key: true


    Event.create!(name: 'test') if Event.count == 0
    default_event = Event.first

    Plan.reset_column_information
    Schedule.reset_column_information
    Speaker.reset_column_information

    Plan.update_all(event_id: default_event.id)
    Schedule.update_all(event_id: default_event.id)
    Speaker.update_all(event_id: default_event.id)

    change_column :plans, :event_id, :uuid, foreign_key: true, null: false
    change_column :schedules, :event_id, :uuid, foreign_key: true, null: false
    change_column :speakers, :event_id, :uuid, foreign_key: true, null: false
  end

  def down
    remove_column :plans, :event_id
    remove_column :schedules, :event_id
    remove_column :speakers, :event_id
  end
end
