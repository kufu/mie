# frozen_string_literal: true

class AddBeaconShareRadiusMetersToEventThemes < ActiveRecord::Migration[8.0]
  def change
    add_column :event_themes, :beacon_share_radius_meters, :integer, null: false, default: 5000
  end
end
