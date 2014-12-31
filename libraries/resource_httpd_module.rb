class Chef
  class Resource
    class HttpdModule < Chef::Resource::LWRPBase
      self.resource_name = :httpd_module
      actions :create, :delete
      default_action :create

      attribute :filename, kind_of: String
      attribute :httpd_version, kind_of: String
      attribute :instance, kind_of: String, default: 'default'
      attribute :module_name, kind_of: String, name_attribute: true, required: true
      attribute :package_name, kind_of: String

      include HttpdCookbook::Helpers

      def parsed_filename
        return filename if filename
        # Put all exceptions here
        if node['platform_family'] == 'rhel'
          return 'libmodnss.so' if module_name == 'nss'
          return 'mod_rev.so' if module_name == 'revocator'
          return 'libphp5.so' if module_name == 'php'
        end
        "mod_#{module_name}.so"
      end

      def parsed_package_name
        return package_name if package_name
        package_name_for_module(
          module_name,
          parsed_httpd_version,
          node['platform'],
          node['platform_family'],
          node['platform_version']
          )
      end

      def parsed_httpd_version
        return httpd_version if httpd_version
        return httpd_version if httpd_version
        return '2.2' if node['platform_family'] == 'debian' && node['platform_version'] == '10.04'
        return '2.2' if node['platform_family'] == 'debian' && node['platform_version'] == '12.04'
        return '2.2' if node['platform_family'] == 'debian' && node['platform_version'] == '13.04'
        return '2.2' if node['platform_family'] == 'debian' && node['platform_version'] == '13.10'
        return '2.2' if node['platform_family'] == 'debian' && node['platform_version'].to_i == 6
        return '2.2' if node['platform_family'] == 'debian' && node['platform_version'].to_i == 7
        return '2.2' if node['platform_family'] == 'freebsd'
        return '2.2' if node['platform_family'] == 'omnios'
        return '2.2' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 5
        return '2.2' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 6
        return '2.2' if node['platform_family'] == 'suse'
        return '2.4' if node['platform_family'] == 'debian' && node['platform_version'] == '14.04'
        return '2.4' if node['platform_family'] == 'debian' && node['platform_version'] == '14.10'
        return '2.4' if node['platform_family'] == 'debian' && node['platform_version'] == 'jessie/sid'
        return '2.4' if node['platform_family'] == 'fedora'
        return '2.4' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 2013
        return '2.4' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 2014
        return '2.4' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 7
        return '2.4' if node['platform_family'] == 'smartos'
      end
    end
  end
end
