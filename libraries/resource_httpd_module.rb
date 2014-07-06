require 'chef/resource/lwrp_base'
require_relative 'module_platform_info'

class Chef
  class Resource
    class HttpdModule < Chef::Resource
      def initialize(name = nil, run_context = nil)
        super

        extend Opscode::Httpd::Module::Helpers

        @resource_name = :httpd_module
        @action = :create
        @allowed_actions = [:create, :delete]

        @httpd_instance = 'default'
        @httpd_version = '2.2'

        # usually nil
        @package_name = 'apache2'

        # @package_name = package_name_for(
        #   name,
        #   node['platform'],
        #   node['platform_family'],
        #   node['platform_version'],
        #   @httpd_version
        #   )

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
          :httpd_version,
          arg,
          :equal_to => %w(2.2 2.4)
          )
      end

      def package_name(arg = nil)
        set_or_return(
          :package_name,
          arg,
          :kind_of => String
          )
      end

      def filename(arg = nil)
        set_or_return(
          :filename,
          arg,
          :kind_of => String
          )
      end
    end
  end
end
