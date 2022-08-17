plan_table = create_plan_table_props(@plan, @user)
plan_description = create_plan_description_props(@plan, @user)
plan_title = create_plan_title_props(@plan, @user)

json.plan do |node|
  node.id @plan.id

  node.title do |title|
    title.title plan_title[:title]
    title.maxLength plan_title[:maxLength]
    title.form plan_title[:form]
  end

  node.description do |desc|
    desc.description plan_description[:description]
    desc.maxLength plan_description[:maxLength]
    desc.form plan_description[:form]
  end

  if(@user.plans.include?(@plan))
    node.settingButton do |stg|
      plan_setting_button = create_setting_button_props(@plan)
      stg.form plan_setting_button[:form]
    end
  else
    node.makeEditableButton do |edt|
      plan_make_editable_button = create_make_editable_button_props(@plan)
      edt.form plan_make_editable_button[:form]
    end
  end

  node.visible plan_title[:visible]
  node.groupedPlans plan_table[:groupedPlans]
  node.uri plan_table[:uri]
end