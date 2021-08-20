class AddPasswordToPlan < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :password_hash, :string, null: true
  end
end
