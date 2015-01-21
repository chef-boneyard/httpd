require 'chef/provider/lwrp_base'
require_relative 'helpers_rhel'

class Chef
  class Provider
    class HttpdService
      class Rhel < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        include HttpdCookbook::Helpers::Rhel

        action :create do
          # FIXME: make into resource parameters
          lock_file = nil
          mutex = nil

          #
          # Chef resources
          #
          # software installation
          package "#{new_resource.name} :create #{parsed_service_package_name}" do
            package_name parsed_service_package_name
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
          if parsed_version.to_f < 2.4
            %w( log_config logio ).each do |m|
              httpd_module "#{new_resource.name} :create #{m}" do
                module_name m
                httpd_version parsed_version
                instance new_resource.instance
                action :create
              end
            end
          else
            %w( log_config logio unixd version watchdog ).each do |m|
              httpd_module "#{new_resource.name} :create #{m}" do
                module_name m
                httpd_version parsed_version
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
          if parsed_version.to_f < 2.4
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
            httpd_module "#{new_resource.name} :create mpm_#{parsed_mpm}" do
              module_name "mpm_#{parsed_mpm}"
              httpd_version parsed_version
              instance new_resource.instance
              action :create
            end
          end

          # MPM configuration
          httpd_config "#{new_resource.name} :create mpm_#{parsed_mpm}" do
            config_name "mpm_#{parsed_mpm}"
            instance new_resource.instance
            source 'mpm.conf.erb'
            variables(
              maxclients: parsed_maxclients,
              maxconnectionsperchild: parsed_maxconnectionsperchild,
              maxrequestsperchild: parsed_maxrequestsperchild,
              maxrequestworkers: parsed_maxrequestworkers,
              maxspareservers: parsed_maxspareservers,
              maxsparethreads: parsed_maxsparethreads,
              minspareservers: parsed_minspareservers,
              minsparethreads: parsed_minsparethreads,
              mpm: parsed_mpm,
              startservers: parsed_startservers,
              threadlimit: parsed_threadlimit,
              threadsperchild: parsed_threadsperchild
              )
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

          if parsed_version.to_f >= 2.4
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
              error_log: "/var/log/#{apache_name}/error_log",
              include_optionals: include_optionals,
              includes: includes,
              lock_file: lock_file,
              mutex: mutex,
              pid_file: pid_file,
              run_group: parsed_run_group,
              run_user: parsed_run_user,
              server_root: "/etc/#{apache_name}",
              servername: parsed_servername
              )
            cookbook 'httpd'
            action :create
          end

          # Install core modules
          parsed_modules.each do |mod|
            httpd_module "#{new_resource.name} :create #{mod}" do
              module_name mod
              instance new_resource.instance
              httpd_version parsed_version
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
          if parsed_version.to_f < 2.4
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
