# comments!

group 'alice' do
  action :create
end

user 'alice' do
  gid 'alice'
  action :create
end

group 'bob' do
  action :create
end

user 'bob' do
  gid 'bob'
  action :create
end

httpd_service 'default' do
  action :delete
end

# hard code values where we can
httpd_service 'instance-1' do
  contact 'hal@computers.biz'
  keepalive false
  maxkeepaliverequests '2001'
  keepalivetimeout '0'
  listen_addresses nil
  listen_ports %w(8080 4343)
  log_level 'warn'
  version node['httpd']['version']
  run_user 'alice'
  run_group 'alice'
  timeout '4321'
  mpm 'prefork'
  startservers '10'
  minspareservers '10'
  maxspareservers '20'
  action [:create, :start]
end

# pass everything from node attributes
httpd_service 'instance-2' do
  contact node['httpd']['contact']
  keepalive node['httpd']['keepalive']
  maxkeepaliverequests node['httpd']['maxkeepaliverequests']
  keepalivetimeout node['httpd']['keepalivetimeout']
  listen_addresses node['httpd']['listen_addresses']
  listen_ports node['httpd']['listen_ports']
  log_level node['httpd']['log_level']
  version node['httpd']['version']
  run_user node['httpd']['run_user']
  run_group node['httpd']['run_group']
  timeout node['httpd']['timeout']
  mpm node['httpd']['mpm']
  startservers node['httpd']['startservers']
  minspareservers node['httpd']['minspareservers']
  maxspareservers node['httpd']['maxspareservers']
  action [:create, :start]
end
