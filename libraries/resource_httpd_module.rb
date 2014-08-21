require 'chef/resource/lwrp_base'
require_relative 'module_package_info'
require_relative 'service_platform_info'

class Chef
  class Resource
    class HttpdModule < Chef::Resource::LWRPBase
      self.resource_name = :httpd_module
      actions :create, :delete
      default_action :create

      attribute :filename, :kind_of => String
      attribute :httpd_version, :kind_of => String
      attribute :instance, :kind_of => String, :default => 'default'
      attribute :module_name, :kind_of => String, :name_attribute => true, :required => true
      attribute :package_name, :kind_of => String

      include Httpd::Module::Helpers
      include Httpd::Service::Helpers

      def parsed_filename
        return filename if filename
        # Put all exceptions here
        if node['platform_family'] == 'rhel'
          return 'libmodnss.so' if module_name == 'nss'
          return 'mod_rev.so' if module_name == 'revocator'
        end
        "mod_#{module_name}.so"
      end

      def parsed_instance
        return instance if instance
      end

      def parsed_httpd_version
        return httpd_version if httpd_version
        default_httpd_version_for(
          node['platform'],
          node['platform_family'],
          node['platform_version']
          )
      end

      def parsed_module_name
        return module_name if module_name
      end

      def parsed_name
        return name if name
      end

      def parsed_package_name
        return package_name if package_name
        package_name_for_module(
          parsed_module_name,
          parsed_httpd_version,
          node['platform'],
          node['platform_family'],
          node['platform_version']
          )
      end
    end
  end
end
