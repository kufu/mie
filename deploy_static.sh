fc-cache -fv
rm -r public/_next
yarn build
cp -r out/_next public/
cp out/2022.html app/views/static/root2022.html.erb
cp out/2022/schedules.html app/views/schedules/page.html.erb
cp out/2022/plans/\[id\].html app/views/plans/page.html.erb
ruby lib/sedlike.rb app/views/plans/page.html.erb \<\/head\> \<%=\ raw\ @ogpstr\ %\>\<\/head\>
