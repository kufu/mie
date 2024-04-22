class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.string :name

      t.timestamps
    end
  end
end
