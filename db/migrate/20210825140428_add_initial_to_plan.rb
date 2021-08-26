class AddInitialToPlan < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :initial, :boolean, default: true, null: false
  end
end
