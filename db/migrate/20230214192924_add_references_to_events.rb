class AddReferencesToEvents < ActiveRecord::Migration[6.1]
  class MigrationEvent < ActiveRecord::Base
    include UuidPrimaryKey

    self.table_name = :events
  end

  def up
    add_column :plans, :event_id, :string, foreign_key: true
    add_column :schedules, :event_id, :string, foreign_key: true
    add_column :speakers, :event_id, :string, foreign_key: true


    MigrationEvent.create!(name: 'test') if MigrationEvent.count == 0
    default_event = MigrationEvent.first
    Plan.reset_column_information
    Schedule.reset_column_information
    Speaker.reset_column_information

    Plan.update_all(event_id: default_event.id)
    Schedule.update_all(event_id: default_event.id)
    Speaker.update_all(event_id: default_event.id)

    change_column :plans, :event_id, :string, foreign_key: true, null: false
    change_column :schedules, :event_id, :string, foreign_key: true, null: false
    change_column :speakers, :event_id, :string, foreign_key: true, null: false
  end

  def down
    remove_column :plans, :event_id
    remove_column :schedules, :event_id
    remove_column :speakers, :event_id
  end
end
