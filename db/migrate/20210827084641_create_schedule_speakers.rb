class CreateScheduleSpeakers < ActiveRecord::Migration[6.1]
  def change
    create_table :schedule_speakers, id: :string do |t|
      t.string :schedule_id, null: false
      t.string :speaker_id, null: false

      t.timestamps
    end

    remove_column :schedules, :speaker_id, :string
  end
end
