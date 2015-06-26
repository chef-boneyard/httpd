require 'chef/platform/provider_priority_map'
require_relative 'provider_httpd_service_rhel_systemd'
require_relative 'provider_httpd_service_rhel_sysvinit'

if defined? Chef::Platform::ProviderPriorityMap
  Chef::Platform::ProviderPriorityMap.instance.priority(
    :httpd_service,
    [Chef::Provider::HttpdService::Rhel::Systemd,  Chef::Provider::HttpdService::Rhel::Sysvinit],
    platform_family: 'rhel'
  )
end
