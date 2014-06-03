# comments!

group node['httpd']['run_group'] do
  action :create
end

user node['httpd']['run_user'] do
  gid node['httpd']['run_group']
  action :create
end

httpd_service 'instance-1' do
  version node['httpd']['version']
  listen_addresses node['httpd']['listen_addresses']
  listen_ports node['httpd']['listen_ports']
  run_user node['httpd']['run_user']
  run_group node['httpd']['run_group']
  contact node['httpd']['contact']
  timeout node['httpd']['timeout']
  keepalive node['httpd']['keepalive']
  keepaliverequests node['httpd']['keepaliverequests']
  keepalivetimeout node['httpd']['keepalivetimeout']
  action :create
end

httpd_service 'instance-2' do
  version node['httpd']['version']
  listen_addresses node['httpd']['listen_addresses']
  listen_ports node['httpd']['listen_ports']
  run_user node['httpd']['run_user']
  run_group node['httpd']['run_group']
  contact node['httpd']['contact']
  timeout node['httpd']['timeout']
  keepalive node['httpd']['keepalive']
  keepaliverequests node['httpd']['keepaliverequests']
  keepalivetimeout node['httpd']['keepalivetimeout']
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
