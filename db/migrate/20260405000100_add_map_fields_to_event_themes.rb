# frozen_string_literal: true

class AddMapFieldsToEventThemes < ActiveRecord::Migration[8.0]
  def change
    change_table :event_themes, bulk: true do |t|
      t.decimal :map_latitude, precision: 10, scale: 6
      t.decimal :map_longitude, precision: 10, scale: 6
      t.integer :map_zoom, null: false, default: 13
    end
  end
end
