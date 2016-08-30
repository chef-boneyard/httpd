apt_update 'update' if platform_family?('debian')

httpd_module 'auth_basic' do
  httpd_version node['httpd']['version']
  action :create
end

httpd_module 'proxy' do
  httpd_version node['httpd']['version']
  action :create
end

httpd_module 'expires' do
  httpd_version node['httpd']['version']
  action :create
end
