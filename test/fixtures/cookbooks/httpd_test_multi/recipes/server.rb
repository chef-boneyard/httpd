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

# pass everything from node attributes
httpd_service 'instance-1' do
  contact node['httpd']['contact']
  keepalive node['httpd']['keepalive']
  keepaliverequests node['httpd']['keepaliverequests']
  keepalivetimeout node['httpd']['keepalivetimeout']
  listen_addresses node['httpd']['listen_addresses']
  listen_ports node['httpd']['listen_ports']
  log_level node['httpd']['log_level']
  version node['httpd']['version']
  run_user node['httpd']['run_user']
  run_group node['httpd']['run_group']
  timeout node['httpd']['timeout']
  action :create
end

# hard code values where we can
httpd_service 'instance-2' do
  contact 'hal@computers.biz'
  keepalive false
  keepaliverequests '2001'
  keepalivetimeout '0'
  listen_addresses nil
  listen_ports %w(8080 4343)
  log_level 'warn'
  version node['httpd']['version']
  run_user 'alice'
  run_group 'alice'
  timeout '4321'
  action :create
end

# log 'notify restart' do
#   level :info
#   action :write
#   notifies :restart, 'httpd_service[instance-1]'
# end

# log 'notify reload' do
#   level :info
#   action :write
#   notifies :reload, 'httpd_service[instance-2]'
# end
