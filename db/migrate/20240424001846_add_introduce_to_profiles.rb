class AddIntroduceToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :introduce, :text
  end
end
