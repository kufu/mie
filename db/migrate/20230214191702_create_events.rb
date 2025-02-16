class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events, id: :uuid do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
