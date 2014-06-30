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
        @action = :install
        @allowed_actions = [:install, :remove]

        @httpd_instance = 'default'
        @httpd_version = '2.2'

        # usually nil
        @package_name = nil

        # usually the same as resource_name
        @filename = nil     
      end

      def httpd_instance(arg = nil)
        set_or_return(
          :httpd_instance,
          arg,
          :kind_of => String
          )
      end

      def httpd_version(arg = nil)
        set_or_return(
          :httpd_instance,
          arg,
          :equal_to => %w(2.2 2.4)
          )
      end
      
    end
  end
end
