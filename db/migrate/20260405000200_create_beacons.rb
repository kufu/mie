# frozen_string_literal: true

class CreateBeacons < ActiveRecord::Migration[8.0]
  def change
    create_table :beacons, id: :string do |t|
      t.references :event, null: false, type: :string, foreign_key: true
      t.references :profile, null: false, type: :string, foreign_key: true
      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.decimal :longitude, precision: 10, scale: 6, null: false
      t.integer :accuracy_meters
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :beacons, %i[event_id profile_id], unique: true
    add_index :beacons, %i[event_id expires_at]
  end
end
