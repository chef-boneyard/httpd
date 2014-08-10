require 'chef/resource/lwrp_base'
require_relative 'module_package_info'
require_relative 'service_platform_info'

class Chef
  class Resource
    class HttpdModule < Chef::Resource
      def initialize(name = nil, run_context = nil)
        super

        extend Httpd::Module::Helpers
        extend Httpd::Service::Helpers

        @resource_name = :httpd_module
        @module_name = name
        @action = :create
        @allowed_actions = [:create, :delete]

        @instance = 'default'

        # set default values
        @httpd_version = default_httpd_version_for(
          node['platform'],
          node['platform_family'],
          node['platform_version']
          )

        @package_name = package_name_for_module(
          @module_name,
          @httpd_version,
          node['platform'],
          node['platform_family'],
          node['platform_version']
          )
      end

      def module_name(arg = nil)
        set_or_return(
          :module_name,
          arg,
          :kind_of => String
          )
      end

      def instance(arg = nil)
        set_or_return(
          :instance,
          arg,
          :kind_of => String
          )
      end

      def httpd_version(arg = nil)
        package_name package_name_for_module(
          @module_name,
          arg,
          node['platform'],
          node['platform_family'],
          node['platform_version']
          )

        set_or_return(
          :httpd_version,
          arg,
          :callbacks => {
            "not supported for httpd_module[#{name}] on #{node['platform']}-#{node['platform_version']}" => lambda do |_httpd_version|
              true unless package_name_for_module(
                @module_name,
                arg,
                node['platform'],
                node['platform_family'],
                node['platform_version']
                ).nil?
            end
          }
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
