# provider mappings

# config
Chef::Platform.set platform: :debian, resource: :httpd_config, provider: Chef::Provider::HttpdConfig::Debian
Chef::Platform.set platform: :ubuntu, resource: :httpd_config, provider: Chef::Provider::HttpdConfig::Debian
Chef::Platform.set platform: :redhat, resource: :httpd_config, provider: Chef::Provider::HttpdConfig::Rhel
Chef::Platform.set platform: :centos, resource: :httpd_config, provider: Chef::Provider::HttpdConfig::Rhel
Chef::Platform.set platform: :oracle, resource: :httpd_config, provider: Chef::Provider::HttpdConfig::Rhel
Chef::Platform.set platform: :amazon, resource: :httpd_config, provider: Chef::Provider::HttpdConfig::Rhel
Chef::Platform.set platform: :fedora, resource: :httpd_config, provider: Chef::Provider::HttpdConfig::Rhel
Chef::Platform.set platform: :scientific, resource: :httpd_config, provider: Chef::Provider::HttpdConfig::Rhel

# modules
Chef::Platform.set platform: :debian, resource: :httpd_module, provider: Chef::Provider::HttpdModule::Debian
Chef::Platform.set platform: :ubuntu, resource: :httpd_module, provider: Chef::Provider::HttpdModule::Debian
Chef::Platform.set platform: :redhat, resource: :httpd_module, provider: Chef::Provider::HttpdModule::Rhel
Chef::Platform.set platform: :centos, resource: :httpd_module, provider: Chef::Provider::HttpdModule::Rhel
Chef::Platform.set platform: :oracle, resource: :httpd_module, provider: Chef::Provider::HttpdModule::Rhel
Chef::Platform.set platform: :amazon, resource: :httpd_module, provider: Chef::Provider::HttpdModule::Rhel
Chef::Platform.set platform: :fedora, resource: :httpd_module, provider: Chef::Provider::HttpdModule::Rhel
Chef::Platform.set platform: :scientific, resource: :httpd_module, provider: Chef::Provider::HttpdModule::Rhel

# service
Chef::Platform.set platform: :debian, resource: :httpd_service, provider: Chef::Provider::HttpdService::Debian::Sysvinit
Chef::Platform.set platform: :ubuntu, resource: :httpd_service, provider: Chef::Provider::HttpdService::Debian::Sysvinit
Chef::Platform.set platform: :redhat, version: '>= 5.0', resource: :httpd_service, provider: Chef::Provider::HttpdService::Rhel::Sysvinit
Chef::Platform.set platform: :redhat, version: '>= 7.0', resource: :httpd_service, provider: Chef::Provider::HttpdService::Rhel::Systemd
Chef::Platform.set platform: :centos, version: '>= 5.0', resource: :httpd_service, provider: Chef::Provider::HttpdService::Rhel::Sysvinit
Chef::Platform.set platform: :centos, version: '>= 7.0', resource: :httpd_service, provider: Chef::Provider::HttpdService::Rhel::Systemd
Chef::Platform.set platform: :oracle, resource: :httpd_service, provider: Chef::Provider::HttpdService::Rhel::Sysvinit
Chef::Platform.set platform: :amazon, resource: :httpd_service, provider: Chef::Provider::HttpdService::Rhel::Sysvinit
Chef::Platform.set platform: :fedora, resource: :httpd_service, provider: Chef::Provider::HttpdService::Rhel::Systemd
Chef::Platform.set platform: :scientific, resource: :httpd_service, provider: Chef::Provider::HttpdService::Rhel::Sysvinit
