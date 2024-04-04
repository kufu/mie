class RemoveColumnEmailFromProfiles < ActiveRecord::Migration[7.1]
  def change
    remove_column :profiles, :email, type: :string, null: false
  end
end
