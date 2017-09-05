module HttpdCookbook
  class HttpdServiceDebian < HttpdService
    action :create do
      # We need to dynamically render the resource name into the title in
      # order to ensure uniqueness. This avoids cloning via
      # CHEF-3694 and allows ChefSpec to work properly.

      package new_resource.package_name do
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
      if new_resource.version.to_f < 2.4
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
          owner new_resource.run_user
          group new_resource.run_group
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
          run_user: new_resource.run_user,
          run_group: new_resource.run_group,
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
          run_group: new_resource.run_group,
          run_user: new_resource.run_user,
          server_root: "/etc/#{apache_name}",
          servername: new_resource.servername
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
      package "apache2-mpm-#{new_resource.mpm}" do
        action :install
        only_if { requires_mpm_packages? }
      end

      # older apache has mpm statically compiled into binaries

      httpd_module "mpm_#{new_resource.mpm}" do
        instance new_resource.instance
        httpd_version new_resource.version
        package_name new_resource.package_name
        not_if { new_resource.version.to_f < 2.4 }
        action :create
      end

      # MPM configuration
      httpd_config "mpm_#{new_resource.mpm}" do
        instance new_resource.instance
        source 'mpm.conf.erb'
        variables(
          maxclients: new_resource.maxclients,
          maxconnectionsperchild: new_resource.maxconnectionsperchild,
          maxrequestsperchild: new_resource.maxrequestsperchild,
          maxrequestworkers: new_resource.maxrequestworkers,
          maxspareservers: new_resource.maxspareservers,
          maxsparethreads: new_resource.maxsparethreads,
          minspareservers: new_resource.minspareservers,
          minsparethreads: new_resource.minsparethreads,
          mpm: new_resource.mpm,
          startservers: new_resource.startservers,
          threadlimit: new_resource.threadlimit,
          threadsperchild: new_resource.threadsperchild
        )
        cookbook 'httpd'
        action :create
      end

      # make sure there is only one MPM loaded
      case new_resource.mpm
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
      new_resource.modules.each do |mod|
        httpd_module mod do
          instance new_resource.instance
          httpd_version new_resource.version
          package_name new_resource.package_name
          action :create
        end
      end

      # generate the sysvinit or systemd service (defined in subclass)
      create_setup_service
    end

    action :delete do
      delete_stop_service

      # NOTE: Users typically provide minimal attributes in a resource block
      # calling the :delete action.  Do not expect the user to set the version
      # attribute.  Instead, clean up files created for all possible versions.

      # FIXME: template[/usr/sbin/a2enmod], and directory[/var/run/apache2] are
      # shared by all httpd_service resources and never get cleaned up.

      [a2enmod_name, a2dismod_name, a2ensite_name, a2dissite_name].each do |dir|
        link "/usr/sbin/#{dir}" do
          action :delete
        end
      end

      %W(/etc/#{apache_name}
         /var/cache/#{apache_name}
         /var/lock/#{apache_name}
         /var/log/#{apache_name}
         /var/run/#{apache_name}).each do |dir|
        directory dir do
          recursive true
          action :delete
        end
      end
    end

    include HttpdCookbook::Helpers::Debian
  end
end
