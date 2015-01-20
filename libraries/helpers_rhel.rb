module HttpdCookbook
  module Helpers
    module Rhel
      def apache_name
        "httpd-#{new_resource.instance}"
      end

      def libarch
        return 'lib64' if node['kernel']['machine'] == 'x86_64'
        return 'lib64' if node['kernel']['machine'] == 'i686'
      end

      def module_name
        new_resource.module_name
      end

      def module_path
        "/usr/#{libarch}/httpd/modules/#{parsed_filename}"
      end

      def elversion
        return 6 if node['platform_version'].to_i == 2013
        return 6 if node['platform_version'].to_i == 2014
        return 7 if node['platform_version'].to_i == 20
        return 7 if node['platform_version'].to_i == 21
        node['platform_version'].to_i
      end

      def pid_file
        return "/var/run/#{apache_name}.pid" if elversion == 5
        return "/var/run/#{apache_name}/httpd.pid" if elversion == 6
        return "/var/run/#{apache_name}/httpd.pid" if elversion == 7
      end

      def includes
        return unless parsed_version.to_f < 2.4
        [
          'conf.d/*.conf',
          'conf.d/*.load'
        ]
      end

      def include_optionals
        return unless parsed_version.to_f >= 2.4
        [
          'conf.d/*.conf',
          'conf.d/*.load',
          'conf.modules.d/*.conf',
          'conf.modules.d/*.load'
        ]
      end
    end
  end
end
