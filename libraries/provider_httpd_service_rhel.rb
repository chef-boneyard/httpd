require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Rhel < Chef::Provider::HttpdService
        # break common and service specific resources into separate
        # functions to allow overriding in a subclass.
        
        def action_create
          create_common
          create_service
        end

        def action_delete
          delete_service
          delete_common
        end

        # override me in subclass
        def action_restart
          log 'action :restart not implemented' do
            str = 'action :restart implemented on'
            str << ' Chef::Provider::HttpdService::Rhel.'
            str << ' Please use Chef::Provider::HttpdService::Rhel::Sysvinit'
            str << ' or Chef::Provider::HttpdService::Rhel::Systemd'
            message str
            level :info
          end
        end

        # override me in subclass
        def action_reload
          log 'action :reload not implemented' do
            str = 'action :reload implemented on'
            str << ' Chef::Provider::HttpdService::Rhel.'
            str << ' Please use Chef::Provider::HttpdService::Rhel::Sysvinit'
            str << ' or Chef::Provider::HttpdService::Rhel::Systemd'
            message str
            level :info
          end
        end

        # override me in subclass
        def create_service
          log 'action create_service not implemented' do
            str = 'action :create implemented on'
            str << ' Chef::Provider::HttpdService::Rhel.'
            str << ' Please use Chef::Provider::HttpdService::Rhel::Sysvinit'
            str << ' or Chef::Provider::HttpdService::Rhel::Systemd'
            message str
            level :info
          end
        end

        # override me in subclass
        def delete_service
          log 'action delete_service not implemented' do
            str = 'action :delete implemented on'
            str << ' Chef::Provider::HttpdService::Rhel.'
            str << ' Please use Chef::Provider::HttpdService::Rhel::Sysvinit'
            str << ' or Chef::Provider::HttpdService::Rhel::Systemd'
            message str
            level :info
          end
        end

        protected

        def create_common
          #
          # local variables
          #
          case node['kernel']['machine']
          when 'x86_64'
            libarch = 'lib64'
          when 'i686'
            libarch = 'lib'
          end

          # enterprise linux version calculation
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
          end

          # support multiple instances
          new_resource.instance == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.instance}"

          # PID file
          case elversion
          when 5
            pid_file = "/var/run/#{apache_name}.pid"
          when 6
            pid_file = "/var/run/#{apache_name}/httpd.pid"
          when 7
            pid_file = "/var/run/#{apache_name}/httpd.pid"
          end

          # FIXME: parameterize
          lock_file = nil
          mutex = nil

          # Include directories for additional configurtions
          if new_resource.version.to_f < 2.4
            includes = [
              'conf.d/*.conf',
              'conf.d/*.load'
            ]
          else
            include_optionals = [
              'conf.d/*.conf',
              'conf.d/*.load',
              'conf.modules.d/*.conf',
              'conf.modules.d/*.load'
            ]
          end

          #
          # Chef resources
          #
          # software installation
          package "#{new_resource.name} create #{new_resource.package_name}" do
            package_name new_resource.package_name
            notifies :run, "bash[#{new_resource.name} create remove_package_config]", :immediately
            action :install
          end

          bash "#{new_resource.name} create remove_package_config" do
            user 'root'
            code <<-EOC
               rm -f /etc/httpd/conf.d/*
               rm -rf /etc/httpd/conf.modules.d/*
              EOC
            action :nothing
          end

          package "#{new_resource.name} create net-tools" do
            package_name 'net-tools'
            action :install
          end

          # achieve parity with modules statically compiled into
          # debian and ubuntu
          if new_resource.version.to_f < 2.4
            %w( log_config logio ).each do |m|
              httpd_module "#{new_resource.name} create #{m}" do
                module_name m
                httpd_version new_resource.version
                instance new_resource.instance
                notifies :reload, "service[#{new_resource.name} create #{apache_name}]"
                action :create
              end
            end
          else
            %w( log_config logio unixd version watchdog ).each do |m|
              httpd_module "#{new_resource.name} create #{m}" do
                module_name m
                httpd_version new_resource.version
                instance new_resource.instance
                notifies :reload, "service[#{new_resource.name} create #{apache_name}]"
                action :create
              end
            end
          end

          # httpd binary symlinks
          link "#{new_resource.name} create /usr/sbin/#{apache_name}" do
            target_file "/usr/sbin/#{apache_name}"
            to '/usr/sbin/httpd'
            action :create
            not_if { apache_name == 'httpd' }
          end

          # MPM loading
          if new_resource.version.to_f < 2.4
            link "#{new_resource.name} create /usr/sbin/#{apache_name}.worker" do
              target_file "/usr/sbin/#{apache_name}.worker"
              to '/usr/sbin/httpd.worker'
              action :create
              not_if { apache_name == 'httpd' }
            end

            link "#{new_resource.name} create /usr/sbin/#{apache_name}.event" do
              target_file "/usr/sbin/#{apache_name}.event"
              to '/usr/sbin/httpd.event'
              action :create
              not_if { apache_name == 'httpd' }
            end
          else
            httpd_module "#{new_resource.name} create mpm_#{new_resource.mpm}" do
              module_name "mpm_#{new_resource.mpm}"
              httpd_version new_resource.version
              instance new_resource.instance
              notifies :reload, "service[#{new_resource.name} create #{apache_name}]"
              action :create
            end
          end

          # MPM configuration
          httpd_config "#{new_resource.name} create mpm_#{new_resource.mpm}" do
            config_name "mpm_#{new_resource.mpm}"
            instance new_resource.instance
            source 'mpm.conf.erb'
            variables(:config => new_resource)
            cookbook 'httpd'
            notifies :reload, "service[#{new_resource.name} create #{apache_name}]"
            action :create
          end

          # configuration directories
          directory "#{new_resource.name} create /etc/#{apache_name}" do
            path "/etc/#{apache_name}"
            user 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          directory "#{new_resource.name} create /etc/#{apache_name}/conf" do
            path "/etc/#{apache_name}/conf"
            user 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          directory "#{new_resource.name} create /etc/#{apache_name}/conf.d" do
            path "/etc/#{apache_name}/conf.d"
            user 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          unless new_resource.version.to_f < 2.4
            directory "#{new_resource.name} create /etc/#{apache_name}/conf.modules.d" do
              path "/etc/#{apache_name}/conf.modules.d"
              user 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end
          end

          # support directories
          directory "#{new_resource.name} create /usr/#{libarch}/httpd/modules" do
            path "/usr/#{libarch}/httpd/modules"
            user 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          directory "#{new_resource.name} create /var/log/#{apache_name}" do
            path "/var/log/#{apache_name}"
            user 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          link "#{new_resource.name} create /etc/#{apache_name}/logs" do
            target_file "/etc/#{apache_name}/logs"
            to "../../var/log/#{apache_name}"
            action :create
          end

          link "#{new_resource.name} create /etc/#{apache_name}/modules" do
            target_file "/etc/#{apache_name}/modules"
            to "../../usr/#{libarch}/httpd/modules"
            action :create
          end

          # /var/run
          if elversion > 5
            directory "#{new_resource.name} create /var/run/#{apache_name}" do
              path "/var/run/#{apache_name}"
              user 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            link "#{new_resource.name} create /etc/#{apache_name}/run" do
              target_file "/etc/#{apache_name}/run"
              to "../../var/run/#{apache_name}"
              action :create
            end
          else
            link "#{new_resource.name} create /etc/#{apache_name}/run" do
              target_file "/etc/#{apache_name}/run"
              to '../../var/run/'
              action :create
            end
          end

          # configuration files
          template "#{new_resource.name} create /etc/#{apache_name}/conf/magic" do
            path "/etc/#{apache_name}/conf/magic"
            source 'magic.erb'
            owner 'root'
            group 'root'
            mode '0644'
            cookbook 'httpd'
            action :create
          end

          template "#{new_resource.name} create /etc/#{apache_name}/conf/httpd.conf" do
            path "/etc/#{apache_name}/conf/httpd.conf"
            source 'httpd.conf.erb'
            owner 'root'
            group 'root'
            mode '0644'
            variables(
              :config => new_resource,
              :server_root => "/etc/#{apache_name}",
              :error_log => "/var/log/#{apache_name}/error_log",
              :pid_file => pid_file,
              :lock_file => lock_file,
              :mutex => mutex,
              :includes => includes,
              :include_optionals => include_optionals
              )
            cookbook 'httpd'
            notifies :restart, "service[#{new_resource.name} create #{apache_name}]"
            action :create
          end
        end

        def delete_common
          # support multiple instances
          new_resource.instance == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.instance}"

          # enterprise linux version calculation
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
          end

          link "#{new_resource.name} delete /usr/sbin/#{apache_name}" do
            target_file "/usr/sbin/#{apache_name}"
            action :delete
            not_if { apache_name == 'httpd' }
          end

          # MPM loading
          if new_resource.version.to_f < 2.4
            link "#{new_resource.name} delete /usr/sbin/#{apache_name}.worker" do
              target_file "/usr/sbin/#{apache_name}.worker"
              action :delete
              not_if { apache_name == 'httpd' }
            end

            link "#{new_resource.name} delete /usr/sbin/#{apache_name}.event" do
              target_file "/usr/sbin/#{apache_name}.event"
              action :delete
              not_if { apache_name == 'httpd' }
            end
          end

          # configuration directories
          directory "#{new_resource.name} delete /etc/#{apache_name}" do
            path "/etc/#{apache_name}"
            recursive true
            action :delete
          end

          # logs
          directory "#{new_resource.name} delete /var/log/#{apache_name}" do
            path "/var/log/#{apache_name}"
            recursive true
            action :delete
          end

          # /var/run
          if elversion > 5
            directory "#{new_resource.name} delete /var/run/#{apache_name}" do
              path "/var/run/#{apache_name}"
              recursive true
              action :delete
            end

            link "#{new_resource.name} delete /etc/#{apache_name}/run" do
              target_file "/etc/#{apache_name}/run"
              action :delete
            end
          else
            link "#{new_resource.name} delete /etc/#{apache_name}/run" do
              target_file "/etc/#{apache_name}/run"
              action :delete
            end
          end
        end
      end
    end
  end
end
