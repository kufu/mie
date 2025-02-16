class CreateEventTrophies < ActiveRecord::Migration[7.1]
  def change
    create_table :event_trophies, id: :uuid do |t|
      t.references :event, type: :uuid, null: false, foreign_key: true
      t.references :trophy, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    add_index :event_trophies, [:event_id, :trophy_id], unique: true
  end
end
