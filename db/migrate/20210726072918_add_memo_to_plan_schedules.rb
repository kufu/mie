class AddMemoToPlanSchedules < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_schedules, :memo, :string, null: false, default: ""
  end
end
