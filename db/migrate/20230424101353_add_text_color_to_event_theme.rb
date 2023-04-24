class AddTextColorToEventTheme < ActiveRecord::Migration[6.1]
  def change
    add_column :event_themes, :text_color, :string, default: '#23221F', null: false, after: :accent_color
  end
end
