class AddTrackToSchedules < ActiveRecord::Migration[6.1]
  def change
    add_column :schedules, :track_name, :string, null: false
  end
end
