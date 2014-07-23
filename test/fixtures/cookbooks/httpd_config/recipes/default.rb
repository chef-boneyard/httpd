# an service

httpd_service 'default' do
  action :create
end

directory '/var/www/html' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

file '/var/www/html/index.html' do
  owner 'root'
  group 'root'
  mode '0644'
  content 'hello world\n'
  action :create
end

httpd_config 'hello' do
  instance 'default'
  source 'hello.conf.erb'
  action :create
  notifies :reload, 'httpd_service[default]'
end
