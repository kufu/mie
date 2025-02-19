class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams, id: :string do |t|
      t.string :name

      t.timestamps
    end
  end
end
