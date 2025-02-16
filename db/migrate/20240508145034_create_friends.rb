class CreateFriends < ActiveRecord::Migration[7.1]
  def change
    create_table :friends, id: :uuid do |t|
      t.uuid :from, null: false
      t.uuid :to, null: false

      t.timestamps
    end

    add_index :friends, [:from, :to], unique: true
    add_foreign_key :friends, :profiles, column: :from
    add_foreign_key :friends, :profiles, column: :to
  end
end
