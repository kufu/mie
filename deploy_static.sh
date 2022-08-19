fc-cache -fv
rm -r public/_next
yarn build
tar -zxvf archive/2021.tar.gz
cp -r out/_next public/
cp out/2021.html public/
cp -r out/2021 public/
cp out/2022.html app/views/static/root2022.html.erb
cp out/2022/schedules.html app/views/schedules/page.html.erb
cp out/2022/plans/\[id\].html app/views/plans/page.html.erb
cp out/404.html app/views/errors/not_found.html.erb
cp out/500.html app/views/errors/server_error.html.erb
ruby lib/sedlike.rb app/views/plans/page.html.erb \<\/head\> \<%=\ raw\ @ogpstr\ %\>\<\/head\>

if [ "$1" = 'run' ]; then
  bundle exec puma -C config/puma.rb
fi
