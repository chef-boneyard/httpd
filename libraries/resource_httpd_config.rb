class Chef
  class Resource
    class HttpdConfig < Chef::Resource::LWRPBase
      self.resource_name = :httpd_config
      default_action :create
      actions :create, :delete

      attribute :config_name, kind_of: String, name_attribute: true, required: true
      attribute :cookbook, kind_of: String, default: nil
      attribute :httpd_version, kind_of: String, default: nil
      attribute :instance, kind_of: String, default: 'default'
      attribute :source, kind_of: String, default: nil
      attribute :variables, kind_of: [Hash], default: nil

      include HttpdCookbook::Helpers

      def parsed_httpd_version
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
