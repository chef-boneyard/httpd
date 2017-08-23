module HttpdCookbook
  module Helpers
    module Rhel
      def apache_name
        "httpd-#{instance}"
      end

      def libarch
        return 'lib64' if node['kernel']['machine'] == 'x86_64'
        return 'lib' if node['kernel']['machine'] == 'i686'
      end

      def module_path
        if platform_family?('suse')
          "/usr/#{libarch}/apache2/#{filename}"
        else
          "/usr/#{libarch}/httpd/modules/#{filename}"
        end
      end

      # suse compiles in modules and fails to start if you try to load them
      # like they're shared modules
      def built_in_module?(name)
        true if platform_family?('suse') &&
                %w(systemd unixd http so access_compat core mpm_event mpm_prefork mpm_worker).include?(name)
      end

      def http_binary_name
        platform_family?('suse') ? 'httpd2' : 'httpd'
      end

      def elversion
        return 6 if node['platform'] == 'amazon'
        return 7 if node['platform_family'] == 'fedora'
        node['platform_version'].to_i
      end

      def pid_file
        "/var/run/#{apache_name}/httpd.pid"
      end

      def includes
        return unless version.to_f < 2.4
        [
          'conf.d/*.load',
          'conf.d/*.conf',
        ]
      end

      def include_optionals
        return unless version.to_f >= 2.4
        [
          'conf.d/*.load',
          'conf.modules.d/*.load',
          'conf.d/*.conf',
          'conf.modules.d/*.conf',
        ]
      end
    end
  end
end
