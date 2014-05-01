require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class HttpdService < Chef::Resource::LWRPBase
      self.resource_name = :httpd_service
      actions  :create
      default_action :create
    end
  end
end
