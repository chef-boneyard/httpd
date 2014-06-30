require 'chef/resource/lwrp_base'
require_relative 'module_package_name_for'
require_relative 'module_filename_for'

class Chef
  class Resource
    class HttpdModule < Chef::Resource
      def initialize(name = nil, run_context = nil)
        super

        extend Opscode::Httpd::Helpers
        
        @resource_name = :httpd_module
        @action = :create

        @httpd_instance = 'default'        
        @httpd_version = default_version_for(
          node['platform'],
          node['platform_family'],
          node['platform_version']
          )

        # usually nil       
        @package_name = module_package_name_for()

        # usually the same as resource_name
        @filename = module_filename_for()        
      end
    end
  end
end
