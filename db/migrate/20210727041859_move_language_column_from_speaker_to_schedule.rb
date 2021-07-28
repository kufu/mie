class MoveLanguageColumnFromSpeakerToSchedule < ActiveRecord::Migration[6.1]
  def change
    remove_column :speakers, :language, :integer, null: false, default: 0
    add_column :schedules, :language, :integer, null: false, default: 0
  end
end
