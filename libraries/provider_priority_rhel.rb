require 'chef/platform/provider_priority_map'

if defined? Chef::Platform::ResourcePriorityMap
  Chef::Platform::ResourcePriorityMap.instance.priority(
    :httpd_service,
    [HttpdCookbook::HttpdServiceRhelSystemd, HttpdCookbook::HttpdServiceRhelSysvinit],
    platform_family: 'rhel'
  )
end
