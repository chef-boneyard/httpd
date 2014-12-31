require 'chef/provider/lwrp_base'
require_relative 'helpers_rhel'

class Chef
  class Provider
    class HttpdService
      class Rhel < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        include HttpdCookbook::Helpers::Rhel

        def whyrun_supported?
          true
        end

        action :create do
          # FIXME: make into resource parameters
          lock_file = nil
          mutex = nil

          #
          # Chef resources
          #
          # software installation
          package "#{new_resource.name} :create #{new_resource.parsed_package_name}" do
            package_name new_resource.parsed_package_name
            action :install
          end

          # Defined in subclass
          create_stop_system_service

          # FIXME: This is needed for serverspec.
          # Move into a serverspec recipe
          package "#{new_resource.name} :create net-tools" do
            package_name 'net-tools'
            action :install
          end

          # achieve parity with modules statically compiled into
          # debian and ubuntu
          if new_resource.parsed_version.to_f < 2.4
            %w( log_config logio ).each do |m|
              httpd_module "#{new_resource.name} :create #{m}" do
                module_name m
                httpd_version new_resource.parsed_version
                instance new_resource.instance
                action :create
              end
            end
          else
            %w( log_config logio unixd version watchdog ).each do |m|
              httpd_module "#{new_resource.name} :create #{m}" do
                module_name m
                httpd_version new_resource.parsed_version
                instance new_resource.instance
                action :create
              end
            end
          end

          # httpd binary symlinks
          link "#{new_resource.name} :create /usr/sbin/#{apache_name}" do
            target_file "/usr/sbin/#{apache_name}"
            to '/usr/sbin/httpd'
            action :create
            not_if { apache_name == 'httpd' }
          end

          # MPM loading
          if new_resource.parsed_version.to_f < 2.4
            link "#{new_resource.name} :create /usr/sbin/#{apache_name}.worker" do
              target_file "/usr/sbin/#{apache_name}.worker"
              to '/usr/sbin/httpd.worker'
              action :create
              not_if { apache_name == 'httpd' }
            end

            link "#{new_resource.name} :create /usr/sbin/#{apache_name}.event" do
              target_file "/usr/sbin/#{apache_name}.event"
              to '/usr/sbin/httpd.event'
              action :create
              not_if { apache_name == 'httpd' }
            end
          else
            httpd_module "#{new_resource.name} :create mpm_#{new_resource.parsed_mpm}" do
              module_name "mpm_#{new_resource.parsed_mpm}"
              httpd_version new_resource.parsed_version
              instance new_resource.instance
              action :create
            end
          end

          # MPM configuration
          httpd_config "#{new_resource.name} :create mpm_#{new_resource.parsed_mpm}" do
            config_name "mpm_#{new_resource.parsed_mpm}"
            instance new_resource.instance
            source 'mpm.conf.erb'
            variables(config: new_resource)
            cookbook 'httpd'
            action :create
          end

          # configuration directories
          directory "#{new_resource.name} :create /etc/#{apache_name}" do
            path "/etc/#{apache_name}"
            user 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          directory "#{new_resource.name} :create /etc/#{apache_name}/conf" do
            path "/etc/#{apache_name}/conf"
            user 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          directory "#{new_resource.name} :create /etc/#{apache_name}/conf.d" do
            path "/etc/#{apache_name}/conf.d"
            user 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          if new_resource.parsed_version.to_f >= 2.4
            directory "#{new_resource.name} :create /etc/#{apache_name}/conf.modules.d" do
              path "/etc/#{apache_name}/conf.modules.d"
              user 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end
          end

          # support directories
          directory "#{new_resource.name} :create /usr/#{libarch}/httpd/modules" do
            path "/usr/#{libarch}/httpd/modules"
            user 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          directory "#{new_resource.name} :create /var/log/#{apache_name}" do
            path "/var/log/#{apache_name}"
            user 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          link "#{new_resource.name} :create /etc/#{apache_name}/logs" do
            target_file "/etc/#{apache_name}/logs"
            to "../../var/log/#{apache_name}"
            action :create
          end

          link "#{new_resource.name} :create /etc/#{apache_name}/modules" do
            target_file "/etc/#{apache_name}/modules"
            to "../../usr/#{libarch}/httpd/modules"
            action :create
          end

          # /var/run
          if elversion > 5
            directory "#{new_resource.name} :create /var/run/#{apache_name}" do
              path "/var/run/#{apache_name}"
              user 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            link "#{new_resource.name} :create /etc/#{apache_name}/run" do
              target_file "/etc/#{apache_name}/run"
              to "../../var/run/#{apache_name}"
              action :create
            end
          else
            link "#{new_resource.name} :create /etc/#{apache_name}/run" do
              target_file "/etc/#{apache_name}/run"
              to '../../var/run'
              action :create
            end
          end

          # configuration files
          template "#{new_resource.name} :create /etc/#{apache_name}/conf/mime.types" do
            path "/etc/#{apache_name}/conf/mime.types"
            source 'magic.erb'
            owner 'root'
            group 'root'
            mode '0644'
            cookbook 'httpd'
            action :create
          end

          template "#{new_resource.name} :create /etc/#{apache_name}/conf/httpd.conf" do
            path "/etc/#{apache_name}/conf/httpd.conf"
            source 'httpd.conf.erb'
            owner 'root'
            group 'root'
            mode '0644'
            variables(
              config: new_resource,
              server_root: "/etc/#{apache_name}",
              error_log: "/var/log/#{apache_name}/error_log",
              pid_file: pid_file,
              lock_file: lock_file,
              mutex: mutex,
              includes: includes,
              include_optionals: include_optionals
              )
            cookbook 'httpd'
            action :create
          end

          # Install core modules
          new_resource.parsed_modules.each do |mod|
            httpd_module "#{new_resource.name} :create #{mod}" do
              module_name mod
              instance new_resource.instance
              httpd_version new_resource.parsed_version
              action :create
            end
          end
        end

        action :delete do
          delete_stop_service

          link "#{new_resource.name} :delete /usr/sbin/#{apache_name}" do
            target_file "/usr/sbin/#{apache_name}"
            to '/usr/sbin/httpd'
            action :delete
            not_if { apache_name == 'httpd' }
          end

          # MPM loading
          if new_resource.parsed_version.to_f < 2.4
            link "#{new_resource.name} :delete /usr/sbin/#{apache_name}.worker" do
              target_file "/usr/sbin/#{apache_name}.worker"
              to '/usr/sbin/httpd.worker'
              action :delete
              not_if { apache_name == 'httpd' }
            end

            link "#{new_resource.name} :delete /usr/sbin/#{apache_name}.event" do
              target_file "/usr/sbin/#{apache_name}.event"
              to '/usr/sbin/httpd.event'
              action :delete
              not_if { apache_name == 'httpd' }
            end
          end

          # configuration directories
          directory "#{new_resource.name} :delete /etc/#{apache_name}" do
            path "/etc/#{apache_name}"
            owner 'root'
            group 'root'
            mode '0755'
            recursive true
            action :delete
          end

          # logs
          directory "#{new_resource.name} :delete /var/log/#{apache_name}" do
            path "/var/log/#{apache_name}"
            owner 'root'
            group 'root'
            mode '0755'
            recursive true
            action :delete
          end

          # /var/run
          if elversion > 5
            directory "#{new_resource.name} :delete /var/run/#{apache_name}" do
              path "/var/run/#{apache_name}"
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :delete
            end

            link "#{new_resource.name} :delete /etc/#{apache_name}/run" do
              target_file "/etc/#{apache_name}/run"
              action :delete
            end
          else
            link "#{new_resource.name} :delete /etc/#{apache_name}/run" do
              target_file "/etc/#{apache_name}/run"
              action :delete
            end
          end
        end
      end
    end
  end
end
