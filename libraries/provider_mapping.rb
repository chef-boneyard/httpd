Chef::Platform.set :platform => :debian, :resource => :httpd_module, :provider => Chef::Provider::HttpdModule::Debian
Chef::Platform.set :platform => :ubuntu, :resource => :httpd_module, :provider => Chef::Provider::HttpdModule::Debian
Chef::Platform.set :platform => :amazon, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel::Sysvinit
Chef::Platform.set :platform => :centos, :version => '>= 5.0', :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel::Sysvinit
Chef::Platform.set :platform => :centos, :version => '>= 7.0', :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel::Systemd
