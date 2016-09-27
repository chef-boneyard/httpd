module HttpdCookbook
  class HttpdServiceDebian < HttpdService
    action :create do
      # We need to dynamically render the resource name into the title in
      # order to ensure uniqueness. This avoids cloning via
      # CHEF-3694 and allows ChefSpec to work properly.

      package package_name do
        action :install
      end

      # In provider subclass
      create_stop_system_service

      # support directories
      directory "/var/cache/#{apache_name}" do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
      end

      directory "/var/log/#{apache_name}" do
        owner 'root'
        group 'adm'
        mode '0755'
        action :create
      end

      # The init scripts that ship with 2.2 and 2.4 on
      # debian/ubuntu behave differently. 2.2 places in /var/run/apache-name/,
      # and 2.4 stores pids as /var/run/apache2/apache2-service_name
      if version.to_f < 2.4
        directory "/var/run/#{apache_name}" do
          owner 'root'
          group 'adm'
          mode '0755'
          action :create
        end
      else
        directory '/var/run/apache2' do
          owner 'root'
          group 'adm'
          mode '0755'
          action :create
        end
      end

      # configuration directories
      directory "/etc/#{apache_name}" do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      if apache_version.to_f < 2.4
        directory "/etc/#{apache_name}/conf.d" do
          owner 'root'
          group 'root'
          mode '0755'
          action :create
        end
      else
        directory "/etc/#{apache_name}/conf-available" do
          owner 'root'
          group 'root'
          mode '0755'
          action :create
        end

        directory "/etc/#{apache_name}/conf-enabled" do
          owner 'root'
          group 'root'
          mode '0755'
          action :create
        end

        directory "/var/lock/#{apache_name}" do
          owner run_user
          group run_group
          mode '0755'
          action :create
        end
      end

      directory "/etc/#{apache_name}/mods-available" do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
      end

      directory "/etc/#{apache_name}/mods-enabled" do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
      end

      directory "/etc/#{apache_name}/sites-available" do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
      end

      directory "/etc/#{apache_name}/sites-enabled" do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
      end

      # envvars
      template "/etc/#{apache_name}/envvars" do
        source 'envvars.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          run_user: run_user,
          run_group: run_group,
          pid_file: pid_file,
          run_dir: run_dir,
          lock_dir: "/var/lock/#{apache_name}",
          log_dir: "/var/log/#{apache_name}"
        )
        cookbook 'httpd'
        action :create
      end

      # utility scripts
      template '/usr/sbin/a2enmod' do
        source "#{apache_version}/scripts/a2enmod.erb"
        owner 'root'
        group 'root'
        mode '0755'
        cookbook 'httpd'
        action :create
      end

      %w( a2enmod_name a2dismod_name a2ensite_name a2dissite_name ).each do |dir|
        link "/usr/sbin/#{dir}" do
          to '/usr/sbin/a2enmod'
          owner 'root'
          group 'root'
          not_if "test -f /usr/sbin/#{dir}"
          action :create
        end
      end

      # configuration files
      template "/etc/#{apache_name}/mime.types" do
        source 'magic.erb'
        owner 'root'
        group 'root'
        mode '0644'
        cookbook 'httpd'
        action :create
      end

      file "/etc/#{apache_name}/ports.conf" do
        action :delete
      end

      template "/etc/#{apache_name}/apache2.conf" do
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
          run_group: run_group,
          run_user: run_user,
          server_root: "/etc/#{apache_name}",
          servername: servername
        )
        cookbook 'httpd'
        action :create
      end

      # mpm configuration
      #
      # With Apache 2.2, only one mpm package can be installed
      # at any given moment. Installing one will uninstall the
      # others. Therefore, all service instances on debian 7, or
      # ubuntu below 14.04 will need to have the same MPM per
      # machine or container or things can get weird.
      package "apache2-mpm-#{mpm}" do
        action :install
        only_if { requires_mpm_packages? }
      end

      # older apache has mpm statically compiled into binaries

      httpd_module "mpm_#{mpm}" do
        instance new_resource.instance
        httpd_version new_resource.version
        package_name new_resource.package_name
        not_if { new_resource.version.to_f < 2.4 }
        action :create
      end

      # MPM configuration
      httpd_config "mpm_#{mpm}" do
        instance new_resource.instance
        source 'mpm.conf.erb'
        variables(
          maxclients: maxclients,
          maxconnectionsperchild: maxconnectionsperchild,
          maxrequestsperchild: maxrequestsperchild,
          maxrequestworkers: maxrequestworkers,
          maxspareservers: maxspareservers,
          maxsparethreads: maxsparethreads,
          minspareservers: minspareservers,
          minsparethreads: minsparethreads,
          mpm: mpm,
          startservers: startservers,
          threadlimit: threadlimit,
          threadsperchild: threadsperchild
        )
        cookbook 'httpd'
        action :create
      end

      # make sure there is only one MPM loaded
      case mpm
      when 'prefork'
        httpd_config 'mpm_worker' do
          instance new_resource.instance
          action :delete
        end

        httpd_config 'mpm_event' do
          instance new_resource.instance
          action :delete
        end
      when 'worker'
        httpd_config 'mpm_prefork' do
          instance new_resource.instance
          action :delete
        end

        httpd_config 'mpm_event' do
          instance new_resource.instance
          action :delete
        end
      when 'event'
        httpd_config 'mpm_prefork' do
          instance new_resource.instance
          action :delete
        end

        httpd_config 'mpm_worker' do
          instance new_resource.instance
          action :delete
        end
      end

      # Install core modules
      modules.each do |mod|
        httpd_module mod do
          instance new_resource.instance
          httpd_version new_resource.version
          package_name new_resource.package_name
          action :create
        end
      end
    end

    action :delete do
      delete_stop_service

      # support directories
      %w(/var/cache/#{apache_name} /var/log/#{apache_name}).each do |dir|
        directory dir do
          recursive true
          action :delete
        end
      end

      directory "/var/run/#{apache_name}" do
        recursive true
        not_if { apache_name == 'apache2' }
        action :delete
      end

      # configuation directories
      if apache_version.to_f < 2.4
        directory "/etc/#{apache_name}/conf.d" do
          recursive true
          action :delete
        end
      else
        directory "/etc/#{apache_name}/conf-available" do
          owner 'root'
          group 'root'
          mode '0755'
          recursive true
          action :delete
        end

        directory "/etc/#{apache_name}/conf-enabled" do
          recursive true
          action :delete
        end

        directory "/var/lock/#{apache_name}" do
          recursive true
          action :delete
        end
      end

      directory "/etc/#{apache_name}/mods-available" do
        recursive true
        action :delete
      end

      directory "/etc/#{apache_name}/mods-enabled" do
        recursive true
        action :delete
      end

      directory "/etc/#{apache_name}/sites-available" do
        recursive true
        action :delete
      end

      directory "/etc/#{apache_name}/sites-enabled" do
        recursive true
        action :delete
      end

      # utility scripts
      file "/usr/sbin/#{a2enmod_name}" do
        action :delete
      end

      link "/usr/sbin/#{a2dismod_name}" do
        action :delete
      end

      link "/usr/sbin/#{a2ensite_name}" do
        action :delete
      end

      link "/usr/sbin/#{a2dissite_name}" do
        action :delete
      end

      file "/etc/#{apache_name}/mime.types" do
        action :delete
      end

      file "/etc/#{apache_name}/ports.conf" do
        action :delete
      end
    end

    include HttpdCookbook::Helpers::Debian
  end
end
