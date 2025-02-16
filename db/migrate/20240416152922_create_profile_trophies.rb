class CreateProfileTrophies < ActiveRecord::Migration[7.1]
  def change
    create_table :profile_trophies, id: :string do |t|
      t.references :profile, type: :string, null: false, foreign_key: true
      t.references :trophy, type: :string, null: false, foreign_key: true

      t.timestamps
    end
  end
end
