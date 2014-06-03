# comments!

httpd_service node['httpd']['service_name'] do
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
