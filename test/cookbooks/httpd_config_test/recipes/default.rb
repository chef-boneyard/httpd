apt_update 'update'

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

httpd_config 'sensitive' do
  instance 'sensitive'
  source 'sensitive.conf.erb'
  sensitive true
  variables(
    password: 'should_be_hidden')
  action :create
end
