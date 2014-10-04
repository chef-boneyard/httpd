#
# Hello world recipe
#

httpd_service 'default' do
  provider Chef::Provider::HttpdService::Docker
  action :create
end

# httpd_config 'hello' do
#   source 'hello.erb'
#   notifies :restart, 'httpd_service[default]'
# end

# file '/var/www/index.html' do
#   content 'hello there\n'
#   action :create
# end
