class AddSpecialToTrophies < ActiveRecord::Migration[7.1]
  def change
    add_column :trophies, :special, :boolean, null: false, default: false
  end
end
