class RemoveUselessThemeColors < ActiveRecord::Migration[8.0]
  def change
    remove_column :event_themes, :sub_color, :string, default: "#EBE0CE"
    remove_column :event_themes, :accent_color, :string, default: "#D7D165"
    remove_column :event_themes, :text_color, :string, default: "#23221F"
  end
end
