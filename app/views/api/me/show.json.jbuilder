navigation_props = create_navigation_props

json.me do |node|
  node.rootLink '/2022'
  node.schedulesLink navigation_props[:schedulesLink]
  node.plansLink navigation_props[:plansLink]
  node.locales navigation_props[:locales]
end