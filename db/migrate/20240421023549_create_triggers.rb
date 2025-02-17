class CreateTriggers < ActiveRecord::Migration[7.1]
  def change
    create_table :triggers, id: :string do |t|
      t.string :description, null: false
      t.string :key, null: false
      t.json :action, null: false
      t.integer :amount, null: false
      t.datetime :expires_at

      t.timestamps
    end
  end
end
