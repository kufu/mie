class CreateProfileTrophies < ActiveRecord::Migration[7.1]
  def change
    create_table :profile_trophies, id: :uuid do |t|
      t.references :profile, type: :uuid, null: false, foreign_key: true
      t.references :trophy, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
