class AddConditonsToTriggers < ActiveRecord::Migration[7.1]
  def change
    add_column :triggers, :conditions, :json, default: []
  end
end
