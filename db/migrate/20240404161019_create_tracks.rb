class CreateTracks < ActiveRecord::Migration[7.1]
  def change
    create_table :tracks, id: :uuid do |t|
      t.references :event, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :position, null: false, default: 1

      t.timestamps
    end

    add_index :tracks, [:event_id, :name], unique: true
  end
end
