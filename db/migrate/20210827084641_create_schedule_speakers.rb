class CreateScheduleSpeakers < ActiveRecord::Migration[6.1]
  def change
    create_table :schedule_speakers, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.uuid :schedule_id, null: false
      t.uuid :speaker_id, null: false

      t.timestamps
    end

    remove_column :schedules, :speaker_id, :uuid
  end
end
