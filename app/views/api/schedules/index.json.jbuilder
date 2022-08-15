@table_array = create_table_array(@schedules)
json.schedules create_schedule_table_props(@table_array, @plan, @user)