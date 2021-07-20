class CreateTables < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :speakers, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.string :name, null: false
      t.string :handle, null: false, default: ""
      t.string :thumbnail, null: false, default: ""
      t.string :profile, null: false, default: ""
      t.integer :language, null: false, default: 0

      t.timestamps
    end

    create_table :users, id: :uuid, default: -> { 'gen_random_uuid()' }, &:timestamps

    create_table :schedules, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.string :title, null: false
      t.string :description, null: false, default: ""
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.uuid :speaker_id, null: false

      t.timestamps
    end

    create_table :plans, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.string :title, null: false
      t.string :description, null: false, default: ""
      t.uuid :user_id, null: false
      t.boolean :public, null:false, default: false

      t.timestamps
    end

    create_table :plan_schedules, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.uuid :plan_id, null: false
      t.uuid :schedule_id, null: false

      t.timestamps
    end
  end
end
