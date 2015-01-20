module HttpdCookbook
  module Helpers
    module Debian
      # version
      def apache_version
        parsed_version
      end

      # support multiple instances
      def apache_name
        "apache2-#{new_resource.instance}"
      end

      def a2enmod_name
        "a2enmod-#{new_resource.name}"
      end

      def a2dismod_name
        "a2dismod-#{new_resource.name}"
      end

      def a2ensite_name
        "a2ensite-#{new_resource.name}"
      end

      def a2dissite_name
        "a2dissite-#{new_resource.name}"
      end

      # module things
      def module_name
        new_resource.module_name
      end

      def module_path
        "/usr/lib/apache2/modules/#{parsed_filename}"
      end

      # service things
      def includes
        return unless apache_version.to_f < 2.4
        [
          'conf.d/*.conf',
          'mods-enabled/*.load',
          'mods-enabled/*.conf'
        ]
      end

      def include_optionals
        return unless apache_version.to_f >= 2.4
        [
          'conf-enabled/*.conf',
          'mods-enabled/*.load',
          'mods-enabled/*.conf',
          'sites-enabled/*.conf'
        ]
      end

      # calculate platform_and_version from node attributes
      def platform_and_version
        return "debian-#{node['platform_version'].to_i}" if node['platform'] == 'debian'
        return "ubuntu-#{node['platform_version']}" if node['platform'] == 'ubuntu'
      end

      def pid_file
        return "/var/run/#{apache_name}.pid" if apache_version.to_f < 2.4
        "/var/run/apache2/#{apache_name}.pid"
      end

      def run_dir
        return "/var/run/#{apache_name}" if apache_version.to_f < 2.4
        '/var/run/apache2'
      end

      def lock_file
        return "/var/lock/#{apache_name}/accept.lock" if apache_version.to_f < 2.4
        nil
      end

      def mutex
        return nil if apache_version.to_f < 2.4
        "file:/var/lock/#{apache_name} default"
      end
    end
  end
end
