class CreateEventTrophies < ActiveRecord::Migration[7.1]
  def change
    create_table :event_trophies, id: :string do |t|
      t.references :event, type: :string, null: false, foreign_key: true
      t.references :trophy, type: :string, null: false, foreign_key: true

      t.timestamps
    end

    add_index :event_trophies, [:event_id, :trophy_id], unique: true
  end
end
