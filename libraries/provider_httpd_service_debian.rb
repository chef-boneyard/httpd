require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Debian < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          #
          # local variables
          #
          apache_version = new_resource.version

          # support multiple instances
          new_resource.name == 'default' ? apache_name = 'apache2' : apache_name = "apache2-#{new_resource.name}"
          new_resource.name == 'default' ? a2enmod_name = 'a2enmod' : a2enmod_name = "a2enmod-#{new_resource.name}"
          new_resource.name == 'default' ? a2dismod_name = 'a2dismod' : a2dismod_name = "a2dismod-#{new_resource.name}"
          new_resource.name == 'default' ? a2ensite_name = 'a2ensite' : a2ensite_name = "a2ensite-#{new_resource.name}"
          new_resource.name == 'default' ? a2dissite_name = 'a2dissite' : a2dissite_name = "a2dissite-#{new_resource.name}"

          # calculate platform_and_version from node attributes
          case node['platform']
          when 'debian'
            platform_and_version = "debian-#{node['platform_version'].to_i}"
          when 'ubuntu'
            platform_and_version = "ubuntu-#{node['platform_version']}"
          end

          # Include directories for additional configurtions
          if apache_version.to_f < 2.4
            includes = [
              'conf.d/*.conf',
              'mods-enabled/*.load',
              'mods-enabled/*.conf'
            ]
          else
            include_optionals = [
              'conf-enabled/*.conf',
              'mods-enabled/*.load',
              'mods-enabled/*.conf',
              'sites-enabled/*.conf'
            ]
          end

          # apache 2.2 and 2.4 differences
          if apache_version.to_f < 2.4
            pid_file = "/var/run/#{apache_name}.pid"
            run_dir = "/var/run/#{apache_name}"
            lock_file = "/var/lock/#{apache_name}/accept.lock"
            mutex = nil
          else
            pid_file = "/var/run/apache2/#{apache_name}.pid"
            run_dir = "/var/run/apache2"
            lock_file = nil
            mutex = "file:/var/lock/#{apache_name} default"
          end

          #
          # Chef resources
          #

          # We need to dynamically render the resource name into the title in
          # order to ensure uniqueness. This avoids cloning via
          # CHEF-3694 and allows ChefSpec to work properly.

          # software installation
          package "#{new_resource.name} create #{new_resource.package_name}" do
            package_name new_resource.package_name
            notifies :run, "bash[#{new_resource.name} create remove_package_config]", :immediately
            action :install
          end

          bash "#{new_resource.name} create remove_package_config" do
            user 'root'
            code <<-EOH
              for i in `ls /etc/apache2 | egrep -v "envvars|apache2.conf"` ; do rm -rf /etc/apache2/$i ; done
              EOH
            action :nothing
          end

          # support directories
          directory "#{new_resource.name} create /var/cache/#{apache_name}" do
            path "/var/cache/#{apache_name}"
            owner 'root'
            group 'root'
            mode '0755'
            action :create
          end

          directory "#{new_resource.name} create /var/log/#{apache_name}" do
            path "/var/log/#{apache_name}"
            owner 'root'
            group 'adm'
            mode '0755'
            action :create
          end

          # The init scripts that ship with 2.2 and 2.4 on
          # debian/ubuntu behave differently. 2.2 places in /var/run/apache-name/,
          # and 2.4 stores pids as /var/run/apache2/apache2-instance_name
          if new_resource.version.to_f < 2.4
            directory "#{new_resource.name} create /var/run/#{apache_name}" do
              path "/var/run/#{apache_name}"
              owner 'root'
              group 'adm'
              mode '0755'
              action :create
            end
          else
            directory "#{new_resource.name} create /var/run/apache2" do
              path '/var/run/apache2'
              owner 'root'
              group 'adm'
              mode '0755'
              action :create
            end
          end

          # configuration directories
          directory "#{new_resource.name} create /etc/#{apache_name}" do
            path "/etc/#{apache_name}"
            owner 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          if apache_version.to_f < 2.4
            directory "#{new_resource.name} create /etc/#{apache_name}/conf.d" do
              path "/etc/#{apache_name}/conf.d"
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end
          else
            directory "#{new_resource.name} create /etc/#{apache_name}/conf-available" do
              path "/etc/#{apache_name}/conf-available"
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "#{new_resource.name} create /etc/#{apache_name}/conf-enabled" do
              path "/etc/#{apache_name}/conf-enabled"
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "#{new_resource.name} create /var/lock/#{apache_name}" do
              path "/var/lock/#{apache_name}"
              owner new_resource.run_user
              group new_resource.run_group
              mode '0755'
              action :create
            end
          end

          directory "#{new_resource.name} create /etc/#{apache_name}/mods-available" do
            path "/etc/#{apache_name}/mods-available"
            owner 'root'
            group 'root'
            mode '0755'
            action :create
          end

          directory "#{new_resource.name} create /etc/#{apache_name}/mods-enabled" do
            path "/etc/#{apache_name}/mods-enabled"
            owner 'root'
            group 'root'
            mode '0755'
            action :create
          end

          directory "#{new_resource.name} create /etc/#{apache_name}/sites-available" do
            path "/etc/#{apache_name}/sites-available"
            owner 'root'
            group 'root'
            mode '0755'
            action :create
          end

          directory "#{new_resource.name} create /etc/#{apache_name}/sites-enabled" do
            path "/etc/#{apache_name}/sites-enabled"
            owner 'root'
            group 'root'
            mode '0755'
            action :create
          end

          # envvars
         template "#{new_resource.name} create /etc/#{apache_name}/envvars" do
            path "/etc/#{apache_name}/envvars"
            source 'envvars.erb'
            owner 'root'
            group 'root'
            mode '0644'
            variables(
              :run_user => new_resource.run_user,
              :run_group => new_resource.run_group,
              :pid_file => pid_file,
              :run_dir => run_dir,
              :lock_dir => "/var/lock/#{apache_name}",
              :log_dir => "/var/log/#{apache_name}"
              )
            cookbook 'httpd'
            action :create
          end

          # utility scripts
          template "#{new_resource.name} create /usr/sbin/a2enmod" do
            path '/usr/sbin/a2enmod'
            source "#{apache_version}/scripts/a2enmod.erb"
            owner 'root'
            group 'root'
            mode '0755'
            cookbook 'httpd'
            action :create
          end

          link "#{new_resource.name} create /usr/sbin/#{a2enmod_name}" do
            target_file "/usr/sbin/#{a2enmod_name}"
            to '/usr/sbin/a2enmod'
            owner 'root'
            group 'root'
            not_if "test -f /usr/sbin/#{a2enmod_name}"
            action :create
          end

          link "#{new_resource.name} create /usr/sbin/#{a2dismod_name}" do
            target_file "/usr/sbin/#{a2dismod_name}"
            to '/usr/sbin/a2enmod'
            owner 'root'
            group 'root'
            action :create
          end

          link "#{new_resource.name} create /usr/sbin/#{a2ensite_name}" do
            target_file "/usr/sbin/#{a2ensite_name}"
            to '/usr/sbin/a2enmod'
            owner 'root'
            group 'root'
            action :create
          end

          link "#{new_resource.name} create /usr/sbin/#{a2dissite_name}" do
            target_file "/usr/sbin/#{a2dissite_name}"
            to '/usr/sbin/a2enmod'
            owner 'root'
            group 'root'
            action :create
          end

          # configuration files
          template "#{new_resource.name} create /etc/#{apache_name}/magic" do
            path "/etc/#{apache_name}/magic"
            source 'magic.erb'
            owner 'root'
            group 'root'
            mode '0644'
            cookbook 'httpd'
            action :create
          end

          file "#{new_resource.name} create /etc/#{apache_name}/ports.conf" do
            path "/etc/#{apache_name}/ports.conf"
            action :delete
          end

          template "#{new_resource.name} create /etc/#{apache_name}/apache2.conf" do
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
            notifies :restart, "service[#{new_resource.name} create #{apache_name}]"
            action :create
          end

          # init script
          template "#{new_resource.name} create /etc/init.d/#{apache_name}" do
            path "/etc/init.d/#{apache_name}"
            source "#{apache_version}/sysvinit/#{platform_and_version}/apache2.erb"
            owner 'root'
            group 'root'
            mode '0755'
            variables(:apache_name => apache_name)
            cookbook 'httpd'
            action :create
          end

          # mpm configuration
          #
          # With Apache 2.2, only one mpm package can be installed
          # at any given moment. Installing one will uninstall the
          # others. Therefore, all httpd_service instances on debian 7, or
          # ubuntu below 14.04 will need to have the same MPM per
          # machine or container or things can get weird.
          package "#{new_resource.name} create apache2-mpm-#{new_resource.mpm}" do
            package_name "apache2-mpm-#{new_resource.mpm}"
            action :install
          end

          # older apache has mpm statically compiled into binaries
          unless new_resource.version.to_f < 2.4
            httpd_module "#{new_resource.name} create mpm_#{new_resource.mpm}" do
              module_name "mpm_#{new_resource.mpm}"
              httpd_instance new_resource.name
              httpd_version new_resource.version
              action :create
            end
          end

          template "#{new_resource.name} create /etc/#{apache_name}/mods-available/mpm_#{new_resource.mpm}.conf" do
            path "/etc/#{apache_name}/mods-available/mpm_#{new_resource.mpm}.conf"
            source "#{new_resource.version}/mods/mpm.conf.erb"
            owner 'root'
            group 'root'
            mode '0644'
            cookbook 'httpd'
            variables(
              :mpm => new_resource.mpm,
              :startservers => new_resource.startservers,
              :minspareservers => new_resource.minspareservers,
              :maxspareservers => new_resource.maxspareservers,
              :maxclients => new_resource.maxclients,
              :maxrequestsperchild => new_resource.maxrequestsperchild,
              :minsparethreads => new_resource.minsparethreads,
              :maxsparethreads => new_resource.maxsparethreads,
              :threadlimit => new_resource.threadlimit,
              :threadsperchild => new_resource.threadsperchild,
              :maxrequestworkers => new_resource.maxrequestworkers,
              :maxconnectionsperchild => new_resource.maxconnectionsperchild
              )
            action :create
          end

          link "#{new_resource.name} create /etc/#{apache_name}/mods-enabled/mpm_#{new_resource.mpm}.conf" do
            target_file "/etc/#{apache_name}/mods-enabled/mpm_#{new_resource.mpm}.conf"
            to "/etc/#{apache_name}/mods-available/mpm_#{new_resource.mpm}.conf"
            action :create
          end

          # make sure only one mpm is loaded
          case new_resource.mpm
          when 'prefork'
            file "#{new_resource.name} create /etc/#{apache_name}/mods-available/mpm_worker.conf" do
              path "/etc/#{apache_name}/mods-available/mpm_worker.conf"
              action :delete
            end

            link "#{new_resource.name} create /etc/#{apache_name}/mods-enabled/mpm_worker.conf" do
              target_file "/etc/#{apache_name}/mods-enabled/mpm_worker.conf"
              action :delete
            end

            file "#{new_resource.name} create /etc/#{apache_name}/mods-available/mpm_event.conf" do
              path "/etc/#{apache_name}/mods-available/mpm_event.conf"
              action :delete
            end

            link "#{new_resource.name} create /etc/#{apache_name}/mods-enabled/mpm_event.conf" do
              target_file "/etc/#{apache_name}/mods-enabled/mpm_event.conf"
              action :delete
            end

          when 'worker'
            file "#{new_resource.name} create /etc/#{apache_name}/mods-available/mpm_prefork.conf" do
              path "/etc/#{apache_name}/mods-available/mpm_prefork.conf"
              action :delete
            end

            link "#{new_resource.name} create /etc/#{apache_name}/mods-enabled/mpm_prefork.conf" do
              target_file "/etc/#{apache_name}/mods-enabled/mpm_prefork.conf"
              action :delete
            end

            file "#{new_resource.name} create /etc/#{apache_name}/mods-available/mpm_event.conf" do
              path "/etc/#{apache_name}/mods-available/mpm_event.conf"
              action :delete
            end

            link "#{new_resource.name} create /etc/#{apache_name}/mods-enabled/mpm_event.conf" do
              target_file "/etc/#{apache_name}/mods-enabled/mpm_event.conf"
              action :delete
            end

          when 'event'
            file "#{new_resource.name} create /etc/#{apache_name}/mods-available/mpm_prefork.conf" do
              path "/etc/#{apache_name}/mods-available/mpm_prefork.conf"
              action :delete
            end

            link "#{new_resource.name} create /etc/#{apache_name}/mods-enabled/mpm_prefork.conf" do
              target_file "/etc/#{apache_name}/mods-enabled/mpm_prefork.conf"
              action :delete
            end

            file "#{new_resource.name} create /etc/#{apache_name}/mods-available/mpm_worker.conf" do
              path "/etc/#{apache_name}/mods-available/mpm_worker.conf"
              action :delete
            end

            link "#{new_resource.name} create /etc/#{apache_name}/mods-enabled/mpm_worker.conf" do
              target_file "/etc/#{apache_name}/mods-enabled/mpm_worker.conf"
              action :delete
            end
          end

          # service management
          service "#{new_resource.name} create #{apache_name}" do
            service_name apache_name
            if apache_name == 'apache2'
              pattern '/usr/sbin/apache2 -k start'
            else
              pattern "/usr/sbin/apache2 -d /etc/#{apache_name} -k start"
            end
            start_command "/usr/sbin/apache2 -d /etc/#{apache_name} -k start"
            stop_command "/usr/sbin/apache2 -d /etc/#{apache_name} -k stop"
            restart_command "/usr/sbin/apache2 -d /etc/#{apache_name} -k restart"
            reload_command "/usr/sbin/apache2 -d /etc/#{apache_name} -k graceful"
            supports :restart => true, :reload => true, :status => false
            provider Chef::Provider::Service::Init::Debian
            action [:start, :enable]
          end
        end

        action :delete do
          # local variables
          apache_version = new_resource.version

          # support multiple instances
          new_resource.name == 'default' ? apache_name = 'apache2' : apache_name = "apache2-#{new_resource.name}"
          new_resource.name == 'default' ? a2enmod_name = 'a2enmod' : a2enmod_name = "a2enmod-#{new_resource.name}"
          new_resource.name == 'default' ? a2dismod_name = 'a2dismod' : a2dismod_name = "a2dismod-#{new_resource.name}"
          new_resource.name == 'default' ? a2ensite_name = 'a2ensite' : a2ensite_name = "a2ensite-#{new_resource.name}"
          new_resource.name == 'default' ? a2dissite_name = 'a2dissite' : a2dissite_name = "a2dissite-#{new_resource.name}"

          # calculate platform_and_version from node attributes
          case node['platform']
          when 'debian'
            platform_and_version = "debian-#{node['platform_version'].to_i}"
          when 'ubuntu'
            platform_and_version = "ubuntu-#{node['platform_version']}"
          end

          # We need to dynamically render the resource name into the title in
          # order to ensure uniqueness. In addition to this, we need
          # to render the extra string 'delete' to isolate it from action
          # :create This avoids cloning via CHEF-3694 and allows
          # ChefSpec to work properly.

          # Software installation: This is needed to supply the init
          # script that powers the service facility.
          package "#{new_resource.name} delete #{new_resource.package_name}" do
            package_name new_resource.package_name
            notifies :run, "bash[#{new_resource.name} delete remove_package_config]", :immediately
            action :install
          end

          bash "#{new_resource.name} delete remove_package_config" do
            user 'root'
            code <<-EOH
              for i in `ls /etc/apache2 | egrep -v "envvars|apache2.conf"` ; do rm -rf /etc/apache2/$i ; done
              EOH
            action :nothing
          end

          template "#{new_resource.name} delete /etc/init.d/#{apache_name}" do
            path "/etc/init.d/#{apache_name}"
            source "#{apache_version}/sysvinit/#{platform_and_version}/apache2.erb"
            owner 'root'
            group 'root'
            mode '0755'
            variables(:apache_name => apache_name)
            cookbook 'httpd'
            action :create
          end

          # service management
          service "#{new_resource.name} delete #{apache_name}" do
            service_name apache_name
            #            pattern apache_name
            action [:disable, :stop]
            provider Chef::Provider::Service::Init::Debian
          end

          # support directories
          directory "#{new_resource.name} delete /var/cache/#{apache_name}" do
            path "/var/cache/#{apache_name}"
            recursive true
            action :delete
          end

          directory "#{new_resource.name} delete /var/log/#{apache_name}" do
            path "/var/log/#{apache_name}"
            recursive true
            action :delete
          end

          directory "#{new_resource.name} delete /var/run/#{apache_name}" do
            path "/var/run/#{apache_name}"
            recursive true
            action :delete
          end

          # configuation directories
          if apache_version.to_f < 2.4
            directory "#{new_resource.name} delete /etc/#{apache_name}/conf.d" do
              path "/etc/#{apache_name}/conf.d"
              recursive true
              action :delete
            end
          else
            directory "#{new_resource.name} delete /etc/#{apache_name}/conf-available" do
              path "/etc/#{apache_name}/conf-available"
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :delete
            end

            directory "#{new_resource.name} delete /etc/#{apache_name}/conf-enabled" do
              path "/etc/#{apache_name}/conf-enabled"
              recursive true
              action :delete
            end

            directory "#{new_resource.name} delete /var/lock/#{apache_name}" do
              path "/var/lock/#{apache_name}"
              recursive true
              action :delete
            end
          end

          directory "#{new_resource.name} delete /etc/#{apache_name}/mods-available" do
            path "/etc/#{apache_name}/mods-available"
            recursive true
            action :delete
          end

          directory "#{new_resource.name} delete /etc/#{apache_name}/mods-enabled" do
            path "/etc/#{apache_name}/mods-enabled"
            recursive true
            action :delete
          end

          directory "#{new_resource.name} delete /etc/#{apache_name}/sites-available" do
            path "/etc/#{apache_name}/sites-available"
            recursive true
            action :delete
          end

          directory "#{new_resource.name} delete /etc/#{apache_name}/sites-enabled" do
            path "/etc/#{apache_name}/sites-enabled"
            recursive true
            action :delete
          end

          # utility scripts
          file "#{new_resource.name} delete /usr/sbin/#{a2enmod_name}" do
            path "/usr/sbin/#{a2enmod_name}"
            action :delete
          end

          link "#{new_resource.name} delete /usr/sbin/#{a2dismod_name}" do
            target_file "/usr/sbin/#{a2dismod_name}"
            action :delete
          end

          link "#{new_resource.name} delete /usr/sbin/#{a2ensite_name}" do
            target_file "/usr/sbin/#{a2ensite_name}"
            action :delete
          end

          link "#{new_resource.name} delete /usr/sbin/#{a2dissite_name}" do
            target_file "/usr/sbin/#{a2dissite_name}"
            action :delete
          end

          file "#{new_resource.name} delete /etc/#{apache_name}/magic" do
            path "/etc/#{apache_name}/magic"
            action :delete
          end

          file "#{new_resource.name} delete /etc/#{apache_name}/ports.conf" do
            path "/etc/#{apache_name}/ports.conf"
            action :delete
          end
        end

        action :restart do
          new_resource.name == 'default' ? apache_name = 'apache2' : apache_name = "apache2-#{new_resource.name}"
          service "#{new_resource.name} create #{apache_name}" do
            service_name apache_name
            if apache_name == 'apache2'
              pattern '/usr/sbin/apache2 -k start'
            else
              pattern "/usr/sbin/apache2 -d /etc/#{apache_name} -k start"
            end
            start_command "/usr/sbin/apache2 -d /etc/#{apache_name} -k start"
            stop_command "/usr/sbin/apache2 -d /etc/#{apache_name} -k stop"
            restart_command "/usr/sbin/apache2 -d /etc/#{apache_name} -k restart"
            reload_command "/usr/sbin/apache2 -d /etc/#{apache_name} -k graceful"
            supports :restart => true, :reload => true, :status => false
            provider Chef::Provider::Service::Init::Debian
            action :restart
          end
        end

        action :reload do
          new_resource.name == 'default' ? apache_name = 'apache2' : apache_name = "apache2-#{new_resource.name}"
          service "#{new_resource.name} create #{apache_name}" do
            service_name apache_name
            if apache_name == 'apache2'
              pattern '/usr/sbin/apache2 -k start'
            else
              pattern "/usr/sbin/apache2 -d /etc/#{apache_name} -k start"
            end
            start_command "/usr/sbin/apache2 -d /etc/#{apache_name} -k start"
            stop_command "/usr/sbin/apache2 -d /etc/#{apache_name} -k stop"
            restart_command "/usr/sbin/apache2 -d /etc/#{apache_name} -k restart"
            reload_command "/usr/sbin/apache2 -d /etc/#{apache_name} -k graceful"
            supports :restart => true, :reload => true, :status => false
            provider Chef::Provider::Service::Init::Debian
            action :reload
          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :debian, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Debian
Chef::Platform.set :platform => :ubuntu, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Debian
