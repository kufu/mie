class RemoveTrophiesIconUrl < ActiveRecord::Migration[8.0]
  def change
    remove_column :trophies, :icon_url, :string, null: false
  end
end
