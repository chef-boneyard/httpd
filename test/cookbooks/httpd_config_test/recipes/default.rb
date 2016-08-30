apt_update 'update' if platform_family?('debian')

httpd_config 'hello' do
  instance 'default'
  source 'hello.conf.erb'
  action :create
end

httpd_config 'hello_again' do
  instance 'foo'
  source 'hello.conf.erb'
  action :create
end
