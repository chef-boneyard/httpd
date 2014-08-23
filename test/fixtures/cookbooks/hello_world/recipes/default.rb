
httpd_service 'default' do
  action :create
end

httpd_module 'authz_host' do
  action :create
  notifies :restart, 'httpd_service[default]'
end

httpd_module 'alias' do
  action :create
  notifies :restart, 'httpd_service[default]'
end

httpd_config '000-default' do
  source '000-default.erb'
  notifies :restart, 'httpd_service[default]'
end
