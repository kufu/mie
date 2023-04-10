class CreateEventThemes < ActiveRecord::Migration[6.1]
  def change
    create_table :event_themes, id: :uuid, default: -> { 'gen_random_uuid()' }  do |t|
      t.uuid :event_id, null: false, foreign_key: true
      t.string :main_color, null: false, default: '#0B374D'
      t.string :sub_color, null: false, default: '#EBE0CE'
      t.string :accent_color, null: false, default: '#D7D165'
      t.string :overview, null: false, default: ''
      t.string :site_label, null: false, default: ''
      t.string :site_url, null: false, default: ''
      t.timestamps
    end
  end
end
