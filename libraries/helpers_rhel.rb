module Httpd
  module Helpers
    module Rhel
      def apache_name
        new_resource.parsed_instance == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.parsed_instance}"
        apache_name
      end

      def libarch
        case node['kernel']['machine']
        when 'x86_64'
          libarch = 'lib64'
        when 'i686'
          libarch = 'lib'
        end
        libarch
      end

      def module_name
        module_name = new_resource.parsed_module_name
        module_name
      end

      def module_path
        module_path = "/usr/#{libarch}/httpd/modules/#{new_resource.parsed_filename}"
        module_path
      end

      def elversion
        case node['platform_version'].to_i
        when 5
          elversion = 5
        when 6
          elversion = 6
        when 7
          elversion = 7
        when 2013
          elversion = 6
        when 2014
          elversion = 6
        when 20
          elversion = 7
        when 21
          elversion = 7
        end
        elversion
      end

      def pid_file
        # PID file
        case elversion
        when 5
          pid_file = "/var/run/#{apache_name}.pid"
        when 6
          pid_file = "/var/run/#{apache_name}/httpd.pid"
        when 7
          pid_file = "/var/run/#{apache_name}/httpd.pid"
        end
        pid_file
      end

      def includes
        return unless new_resource.parsed_version.to_f < 2.4
        includes = [
          'conf.d/*.conf',
          'conf.d/*.load'
        ]
        includes
      end

      def include_optionals
        return unless new_resource.parsed_version.to_f >= 2.4
        include_optionals = [
          'conf.modules.d/*.conf',
          'conf.modules.d/*.load',
          'conf.d/*.conf',
          'conf.d/*.load'
        ]
        include_optionals
      end
    end
  end
end
