require 'chef/provider/lwrp_base'
require_relative 'helpers_debian'

class Chef
  class Provider
    class HttpdService
      class Debian < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        include Httpd::Helpers::Debian

        def whyrun_supported?
          true
        end

        # break common and service resources into separate
        # functions to allow for overriding in a subclass.
        action :create do
          create_common
          create_service
        end

        action :delete do
          delete_service
          delete_common
        end

        # override me in subclass
        action :restart do
          log 'action :restart not implemented' do
            str = 'action :restart implemented on'
            str << ' Chef::Provider::HttpdService::Debian.'
            str << ' Please use Chef::Provider::HttpdService::Debian::Sysvinit'
            message str
            level :info
          end
        end

        # override me in subclass
        action :reload do
          log 'action :reload not implemented' do
            str = 'action :reload not implemented on'
            str << ' Chef::Provider::HttpdService::Debian.'
            str << ' Please use Chef::Provider::HttpdService::Debian::Sysvinit'
            message str
            level :info
          end
        end

        # override me in subclass
        def delete_service
          log 'delete_service not implemented' do
            str = 'delete_service not implemented on'
            str << ' Chef::Provider::HttpdService::Debian.'
            str << ' Please use Chef::Provider::HttpdService::Debian::Sysvinit'
            message str
            level :info
          end
        end

        def create_common
          # We need to dynamically render the resource name into the title in
          # order to ensure uniqueness. This avoids cloning via
          # CHEF-3694 and allows ChefSpec to work properly.

          package "#{new_resource.parsed_name} create #{new_resource.parsed_package_name}" do
            package_name new_resource.parsed_package_name
            notifies :run, "bash[#{new_resource.parsed_name} create remove_package_config]", :immediately
            action :install
          end

          bash "#{new_resource.parsed_name} create remove_package_config" do
            user 'root'
            code <<-EOH
              for i in `ls /etc/apache2 | egrep -v "envvars|apache2.conf"` ; do rm -rf /etc/apache2/$i ; done
              EOH
            action :nothing
          end

          # support directories
          directory "#{new_resource.parsed_name} create /var/cache/#{apache_name}" do
            path "/var/cache/#{apache_name}"
            owner 'root'
            group 'root'
            mode '0755'
            action :create
          end

          directory "#{new_resource.parsed_name} create /var/log/#{apache_name}" do
            path "/var/log/#{apache_name}"
            owner 'root'
            group 'adm'
            mode '0755'
            action :create
          end

          # The init scripts that ship with 2.2 and 2.4 on
          # debian/ubuntu behave differently. 2.2 places in /var/run/apache-name/,
          # and 2.4 stores pids as /var/run/apache2/apache2-service_name
          if new_resource.parsed_version.to_f < 2.4
            directory "#{new_resource.parsed_name} create /var/run/#{apache_name}" do
              path "/var/run/#{apache_name}"
              owner 'root'
              group 'adm'
              mode '0755'
              action :create
            end
          else
            directory "#{new_resource.parsed_name} create /var/run/apache2" do
              path '/var/run/apache2'
              owner 'root'
              group 'adm'
              mode '0755'
              action :create
            end
          end

          # configuration directories
          directory "#{new_resource.parsed_name} create /etc/#{apache_name}" do
            path "/etc/#{apache_name}"
            owner 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          if apache_version.to_f < 2.4
            directory "#{new_resource.parsed_name} create /etc/#{apache_name}/conf.d" do
              path "/etc/#{apache_name}/conf.d"
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end
          else
            directory "#{new_resource.parsed_name} create /etc/#{apache_name}/conf-available" do
              path "/etc/#{apache_name}/conf-available"
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "#{new_resource.parsed_name} create /etc/#{apache_name}/conf-enabled" do
              path "/etc/#{apache_name}/conf-enabled"
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "#{new_resource.parsed_name} create /var/lock/#{apache_name}" do
              path "/var/lock/#{apache_name}"
              owner new_resource.parsed_run_user
              group new_resource.parsed_run_group
              mode '0755'
              action :create
            end
          end

          directory "#{new_resource.parsed_name} create /etc/#{apache_name}/mods-available" do
            path "/etc/#{apache_name}/mods-available"
            owner 'root'
            group 'root'
            mode '0755'
            action :create
          end

          directory "#{new_resource.parsed_name} create /etc/#{apache_name}/mods-enabled" do
            path "/etc/#{apache_name}/mods-enabled"
            owner 'root'
            group 'root'
            mode '0755'
            action :create
          end

          directory "#{new_resource.parsed_name} create /etc/#{apache_name}/sites-available" do
            path "/etc/#{apache_name}/sites-available"
            owner 'root'
            group 'root'
            mode '0755'
            action :create
          end

          directory "#{new_resource.parsed_name} create /etc/#{apache_name}/sites-enabled" do
            path "/etc/#{apache_name}/sites-enabled"
            owner 'root'
            group 'root'
            mode '0755'
            action :create
          end

          # envvars
          template "#{new_resource.parsed_name} create /etc/#{apache_name}/envvars" do
            path "/etc/#{apache_name}/envvars"
            source 'envvars.erb'
            owner 'root'
            group 'root'
            mode '0644'
            variables(
              :run_user => new_resource.parsed_run_user,
              :run_group => new_resource.parsed_run_group,
              :pid_file => pid_file,
              :run_dir => run_dir,
              :lock_dir => "/var/lock/#{apache_name}",
              :log_dir => "/var/log/#{apache_name}"
              )
            cookbook 'httpd'
            action :create
          end

          # utility scripts
          template "#{new_resource.parsed_name} create /usr/sbin/a2enmod" do
            path '/usr/sbin/a2enmod'
            source "#{apache_version}/scripts/a2enmod.erb"
            owner 'root'
            group 'root'
            mode '0755'
            cookbook 'httpd'
            action :create
          end

          link "#{new_resource.parsed_name} create /usr/sbin/#{a2enmod_name}" do
            target_file "/usr/sbin/#{a2enmod_name}"
            to '/usr/sbin/a2enmod'
            owner 'root'
            group 'root'
            not_if "test -f /usr/sbin/#{a2enmod_name}"
            action :create
          end

          link "#{new_resource.parsed_name} create /usr/sbin/#{a2dismod_name}" do
            target_file "/usr/sbin/#{a2dismod_name}"
            to '/usr/sbin/a2enmod'
            owner 'root'
            group 'root'
            action :create
          end

          link "#{new_resource.parsed_name} create /usr/sbin/#{a2ensite_name}" do
            target_file "/usr/sbin/#{a2ensite_name}"
            to '/usr/sbin/a2enmod'
            owner 'root'
            group 'root'
            action :create
          end

          link "#{new_resource.parsed_name} create /usr/sbin/#{a2dissite_name}" do
            target_file "/usr/sbin/#{a2dissite_name}"
            to '/usr/sbin/a2enmod'
            owner 'root'
            group 'root'
            action :create
          end

          # configuration files
          template "#{new_resource.parsed_name} create /etc/#{apache_name}/magic" do
            path "/etc/#{apache_name}/magic"
            source 'magic.erb'
            owner 'root'
            group 'root'
            mode '0644'
            cookbook 'httpd'
            action :create
          end

          file "#{new_resource.parsed_name} create /etc/#{apache_name}/ports.conf" do
            path "/etc/#{apache_name}/ports.conf"
            action :delete
          end

          template "#{new_resource.parsed_name} create /etc/#{apache_name}/apache2.conf" do
            path "/etc/#{apache_name}/apache2.conf"
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
            notifies :restart, "service[#{new_resource.parsed_name} create #{apache_name}]"
            action :create
          end

          # mpm configuration
          #
          # With Apache 2.2, only one mpm package can be installed
          # at any given moment. Installing one will uninstall the
          # others. Therefore, all service instances on debian 7, or
          # ubuntu below 14.04 will need to have the same MPM per
          # machine or container or things can get weird.
          package "#{new_resource.parsed_name} create apache2-mpm-#{new_resource.parsed_mpm}" do
            package_name "apache2-mpm-#{new_resource.parsed_mpm}"
            action :install
          end

          # older apache has mpm statically compiled into binaries
          unless new_resource.parsed_version.to_f < 2.4
            httpd_module "#{new_resource.parsed_name} create mpm_#{new_resource.parsed_mpm}" do
              module_name "mpm_#{new_resource.parsed_mpm}"
              instance new_resource.parsed_instance
              httpd_version new_resource.parsed_version
              notifies :reload, "service[#{new_resource.parsed_name} create #{apache_name}]"
              action :create
            end
          end

          httpd_config "#{new_resource.parsed_name} create mpm_#{new_resource.parsed_mpm}" do
            config_name "mpm_#{new_resource.parsed_mpm}"
            instance new_resource.parsed_instance
            source 'mpm.conf.erb'
            variables(:config => new_resource)
            cookbook 'httpd'
            notifies :reload, "service[#{new_resource.parsed_name} create #{apache_name}]"
            action :create
          end

          # make sure there is only one MPM loaded
          case new_resource.parsed_mpm
          when 'prefork'
            httpd_config "#{new_resource.parsed_name} create mpm_worker" do
              config_name 'mpm_worker'
              instance new_resource.parsed_instance
              action :delete
            end

            httpd_config "#{new_resource.parsed_name} create mpm_event" do
              config_name 'mpm_event'
              instance new_resource.parsed_instance
              action :delete
            end
          when 'worker'
            httpd_config "#{new_resource.parsed_name} create mpm_prefork" do
              config_name 'mpm_prefork'
              instance new_resource.parsed_instance
              action :delete
            end

            httpd_config "#{new_resource.parsed_name} create mpm_event" do
              config_name 'mpm_event'
              instance new_resource.parsed_instance
              action :delete
            end
          when 'event'
            httpd_config "#{new_resource.parsed_name} create mpm_prefork" do
              config_name 'mpm_prefork'
              instance new_resource.parsed_instance
              action :delete
            end

            httpd_config "#{new_resource.parsed_name} create mpm_worker" do
              config_name 'mpm_worker'
              instance new_resource.parsed_instance
              action :delete
            end
          end
        end

        def delete_common
          # support directories
          directory "#{new_resource.parsed_name} delete /var/cache/#{apache_name}" do
            path "/var/cache/#{apache_name}"
            recursive true
            action :delete
          end

          directory "#{new_resource.parsed_name} delete /var/log/#{apache_name}" do
            path "/var/log/#{apache_name}"
            recursive true
            action :delete
          end

          directory "#{new_resource.parsed_name} delete /var/run/#{apache_name}" do
            path "/var/run/#{apache_name}"
            recursive true
            not_if { apache_name == 'apache2' }
            action :delete
          end

          # configuation directories
          if apache_version.to_f < 2.4
            directory "#{new_resource.parsed_name} delete /etc/#{apache_name}/conf.d" do
              path "/etc/#{apache_name}/conf.d"
              recursive true
              action :delete
            end
          else
            directory "#{new_resource.parsed_name} delete /etc/#{apache_name}/conf-available" do
              path "/etc/#{apache_name}/conf-available"
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :delete
            end

            directory "#{new_resource.parsed_name} delete /etc/#{apache_name}/conf-enabled" do
              path "/etc/#{apache_name}/conf-enabled"
              recursive true
              action :delete
            end

            directory "#{new_resource.parsed_name} delete /var/lock/#{apache_name}" do
              path "/var/lock/#{apache_name}"
              recursive true
              action :delete
            end
          end

          directory "#{new_resource.parsed_name} delete /etc/#{apache_name}/mods-available" do
            path "/etc/#{apache_name}/mods-available"
            recursive true
            action :delete
          end

          directory "#{new_resource.parsed_name} delete /etc/#{apache_name}/mods-enabled" do
            path "/etc/#{apache_name}/mods-enabled"
            recursive true
            action :delete
          end

          directory "#{new_resource.parsed_name} delete /etc/#{apache_name}/sites-available" do
            path "/etc/#{apache_name}/sites-available"
            recursive true
            action :delete
          end

          directory "#{new_resource.parsed_name} delete /etc/#{apache_name}/sites-enabled" do
            path "/etc/#{apache_name}/sites-enabled"
            recursive true
            action :delete
          end

          # utility scripts
          file "#{new_resource.parsed_name} delete /usr/sbin/#{a2enmod_name}" do
            path "/usr/sbin/#{a2enmod_name}"
            action :delete
          end

          link "#{new_resource.parsed_name} delete /usr/sbin/#{a2dismod_name}" do
            target_file "/usr/sbin/#{a2dismod_name}"
            action :delete
          end

          link "#{new_resource.parsed_name} delete /usr/sbin/#{a2ensite_name}" do
            target_file "/usr/sbin/#{a2ensite_name}"
            action :delete
          end

          link "#{new_resource.parsed_name} delete /usr/sbin/#{a2dissite_name}" do
            target_file "/usr/sbin/#{a2dissite_name}"
            action :delete
          end

          file "#{new_resource.parsed_name} delete /etc/#{apache_name}/magic" do
            path "/etc/#{apache_name}/magic"
            action :delete
          end

          file "#{new_resource.parsed_name} delete /etc/#{apache_name}/ports.conf" do
            path "/etc/#{apache_name}/ports.conf"
            action :delete
          end
        end
      end
    end
  end
end
