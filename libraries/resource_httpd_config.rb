require 'chef/resource/lwrp_base'
require_relative 'service_platform_info'

class Chef
  class Resource
    class HttpdConfig < Chef::Resource::LWRPBase
      self.resource_name = :httpd_config
      default_action :create
      actions :create, :delete

      attribute :config_name, :kind_of => String, :name_attribute => true, :required => true
      attribute :cookbook, :kind_of => String, :default => nil
      attribute :httpd_version, :kind_of => String, :default => nil
      attribute :instance, :kind_of => String, :default => 'default'
      attribute :source, :kind_of => String, :default => nil
      attribute :variables, :kind_of => [Hash], :default => nil

      include Httpd::Service::Helpers

      def parsed_name
        return name if name
      end

      def parsed_config_name
        return config_name if config_name
      end

      def parsed_cookbook
        return cookbook if cookbook
      end

      def parsed_httpd_version
        return httpd_version if httpd_version
        default_httpd_version_for(
          node['platform'],
          node['platform_family'],
          node['platform_version']
        )
      end

      def parsed_instance
        return instance if instance
      end

      def parsed_source
        return source if source
      end

      def parsed_variables
        return variables if variables
      end
    end
  end
end
