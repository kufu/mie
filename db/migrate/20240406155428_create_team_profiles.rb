class CreateTeamProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :team_profiles, id: :string do |t|
      t.references :team, type: :string, null: false, foreign_key: true
      t.references :profile, type: :string, null: false, foreign_key: true
      t.integer :role, null: false

      t.timestamps
    end

    add_index :team_profiles, [:team_id, :profile_id], unique: true
  end
end
