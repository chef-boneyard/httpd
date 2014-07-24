# an config

httpd_config 'hello' do
  instance 'default'
  source 'hello.conf.erb'
  action :create
  notifies :restart, 'httpd_service[default]'
end
