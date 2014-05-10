# comments!

httpd_service node['httpd']['service_name'] do
  version node['httpd']['version']
  listen_addresses node['httpd']['listen_addresses']
  listen_ports node['httpd']['listen_ports']
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
