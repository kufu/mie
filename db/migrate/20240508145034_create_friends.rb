class CreateFriends < ActiveRecord::Migration[7.1]
  def change
    create_table :friends, id: :string do |t|
      t.string :from, null: false
      t.string :to, null: false

      t.timestamps
    end

    add_index :friends, [:from, :to], unique: true
    add_foreign_key :friends, :profiles, column: :from
    add_foreign_key :friends, :profiles, column: :to
  end
end
