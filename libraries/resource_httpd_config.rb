require 'chef/resource/lwrp_base'
require_relative 'service_platform_info'

class Chef
  class Resource
    class HttpdConfig < Chef::Resource
      def initialize(name = nil, run_context = nil)
        super

        extend Httpd::Service::Helpers

        @resource_name = :httpd_config
        @config_name = name
        @action = :create
        @allowed_actions = [:create, :delete]

        @instance = 'default'
        @source = nil
        @variables = nil
        @cookbook = nil

        @httpd_version = default_httpd_version_for(
          node['platform'],
          node['platform_family'],
          node['platform_version']
          )
      end

      def config_name(arg = nil)
        set_or_return(
          :config_name,
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

      def source(arg = nil)
        set_or_return(
          :source,
          arg,
          :kind_of => String
          )
      end

      def variables(arg = nil)
        set_or_return(
          :variables,
          arg,
          :kind_of => [Hash]
          )
      end

      def cookbook(arg = nil)
        set_or_return(
          :cookbook,
          arg,
          :kind_of => String
          )
      end

      def httpd_version(arg = nil)
        set_or_return(
          :httpd_version,
          arg,
          :kind_of => String
          )
      end
    end
  end
end
