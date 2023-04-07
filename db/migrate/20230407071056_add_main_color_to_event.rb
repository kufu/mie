class AddMainColorToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :main_color, :string, null: false, default: "#0B374D"
  end
end
