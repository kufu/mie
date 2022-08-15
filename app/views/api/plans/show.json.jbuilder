plan_table = create_plan_table_props(@plan, @user)
plan_description = create_plan_description_props(@plan, @user)
plan_title = create_plan_title_props(@plan, @user)

json.plan do |node|
  node.title plan_title[:title]
  node.titleMaxLngth plan_title[:maxLength]
  node.description plan_description[:description]
  node.descriptionMaxLength plan_description[:maxLength]
  node.visible plan_title[:visible]
  node.groupedPlans plan_table[:groupedPlans]
end