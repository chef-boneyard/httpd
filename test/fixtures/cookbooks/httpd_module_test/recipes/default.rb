# comments!

httpd_module 'auth_basic' do
  httpd_version node['httpd']['version']
  action :create
end

httpd_module 'proxy' do
  httpd_version node['httpd']['version']
  action :create
end

httpd_module 'proxy_fcgi' do
  httpd_version node['httpd']['version']
  action :create
end

httpd_module 'auth_kerb' do
  httpd_version node['httpd']['version']
  action :create
end
