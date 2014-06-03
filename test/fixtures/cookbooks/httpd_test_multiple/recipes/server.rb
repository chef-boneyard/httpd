# comments!

group node['httpd']['run_group'] do
  action :create
end

user node['httpd']['run_user'] do
  gid node['httpd']['run_group']
  action :create
end

httpd_service 'default' do
  action :delete
end

httpd_service 'instance-1' do
  contact node['httpd']['contact']
  hostname_lookups node['httpd']['hostname_lookups']
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

httpd_service 'instance-2' do
  contact node['httpd']['contact']
  hostname_lookups node['httpd']['hostname_lookups']
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

log 'notify restart' do
  level :info
  notifies :restart, "httpd_service[#{node['httpd']['service_name']}]"
end

log 'notify reload' do
  level :info
  notifies :reload, "httpd_service[#{node['httpd']['service_name']}]"
end
