module Httpd
  module Helpers
    module Debian
      # version
      def apache_version
        apache_version = new_resource.version
        apache_version
      end

      # support multiple instances
      def apache_name
        new_resource.instance == 'default' ? apache_name = 'apache2' : apache_name = "apache2-#{new_resource.instance}"
        apache_name
      end

      def a2enmod_name
        new_resource.name == 'default' ? a2enmod_name = 'a2enmod' : a2enmod_name = "a2enmod-#{new_resource.name}"
        a2enmod_name
      end

      def a2dismod_name
        new_resource.name == 'default' ? a2dismod_name = 'a2dismod' : a2dismod_name = "a2dismod-#{new_resource.name}"
        a2dismod_name
      end

      def a2ensite_name
        new_resource.name == 'default' ? a2ensite_name = 'a2ensite' : a2ensite_name = "a2ensite-#{new_resource.name}"
        a2ensite_name
      end

      def a2dissite_name
        new_resource.name == 'default' ? a2dissite_name = 'a2dissite' : a2dissite_name = "a2dissite-#{new_resource.name}"
        a2dissite_name
      end

      # module things
      def module_name
        module_name = new_resource.module_name
        module_name
      end

      def module_path
        module_path = "/usr/lib/apache2/modules/mod_#{module_name}.so"
        module_path
      end

      # service things
      def includes
        return unless apache_version.to_f < 2.4
        includes = [
          'conf.d/*.conf',
          'mods-enabled/*.load',
          'mods-enabled/*.conf'
        ]
        includes
      end

      def include_optionals
        return unless apache_version.to_f >= 2.4
        include_optionals = [
          'conf-enabled/*.conf',
          'mods-enabled/*.load',
          'mods-enabled/*.conf',
          'sites-enabled/*.conf'
        ]
        include_optionals
      end

      # calculate platform_and_version from node attributes
      def platform_and_version
        case node['platform']
        when 'debian'
          platform_and_version = "debian-#{node['platform_version'].to_i}"
        when 'ubuntu'
          platform_and_version = "ubuntu-#{node['platform_version']}"
        end
        platform_and_version
      end

      def pid_file
        if apache_version.to_f < 2.4
          pid_file = "/var/run/#{apache_name}.pid"
        else
          pid_file = "/var/run/apache2/#{apache_name}.pid"
        end
        pid_file
      end

      def run_dir
        if apache_version.to_f < 2.4
          run_dir = "/var/run/#{apache_name}"
        else
          run_dir = '/var/run/apache2'
        end
        run_dir
      end

      def lock_file
        if apache_version.to_f < 2.4
          lock_file = "/var/lock/#{apache_name}/accept.lock"
        else
          lock_file = nil
        end
        lock_file
      end

      def mutex
        if apache_version.to_f < 2.4
          mutex = nil
        else
          mutex = "file:/var/lock/#{apache_name} default"
        end
        mutex
      end
    end
  end
end
