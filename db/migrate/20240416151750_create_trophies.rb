class CreateTrophies < ActiveRecord::Migration[7.1]
  def change
    create_table :trophies, id: :uuid do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :icon_url, null: false
      t.integer :rarity, null: false, default: 0
      t.integer :order, null: false, default: 9999

      t.timestamps
    end
  end
end
