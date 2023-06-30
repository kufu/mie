class AddTrackTagToSchedules < ActiveRecord::Migration[6.1]
  def change
    add_column :schedules, :track_tag, :string, default: ''
  end
end
