class CreateTeamProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :team_profiles, id: :uuid do |t|
      t.references :team, type: :uuid, null: false, foreign_key: true
      t.references :profile, type: :uuid, null: false, foreign_key: true
      t.integer :role, null: false

      t.timestamps
    end

    add_index :team_profiles, [:team_id, :profile_id], unique: true
  end
end
