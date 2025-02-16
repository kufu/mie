class CreateTables < ActiveRecord::Migration[6.1]
  def change
    create_table :speakers, id: :string do |t|
      t.string :name, null: false
      t.string :handle, null: false, default: ""
      t.string :thumbnail, null: false, default: ""
      t.string :profile, null: false, default: ""
      t.integer :language, null: false, default: 0

      t.timestamps
    end

    create_table :users, id: :string, &:timestamps

    create_table :schedules, id: :string do |t|
      t.string :title, null: false
      t.string :description, null: false, default: ""
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.string :speaker_id, null: false

      t.timestamps
    end

    create_table :plans, id: :string do |t|
      t.string :title, null: false
      t.string :description, null: false, default: ""
      t.string :user_id, null: false
      t.boolean :public, null:false, default: false

      t.timestamps
    end

    create_table :plan_schedules, id: :string do |t|
      t.string :plan_id, null: false
      t.string :schedule_id, null: false

      t.timestamps
    end
  end
end
