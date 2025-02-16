class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events, id: :string do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
