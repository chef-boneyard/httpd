module HttpdCookbook
  class HttpdServiceRhel < HttpdService
    action :create do
      # FIXME: make into resource parameters
      lock_file = nil
      mutex = nil

      #
      # Chef resources
      #
      # software installation
      package new_resource.package_name

      # Defined in subclass
      create_stop_system_service

      # achieve parity with modules statically compiled into
      # debian and ubuntu
      if new_resource.version.to_f < 2.4
        %w( log_config logio ).each do |m|
          httpd_module m do
            httpd_version new_resource.version
            instance new_resource.instance
            action :create
          end
        end
      else
        %w( log_config logio unixd version watchdog ).each do |m|
          httpd_module m do
            httpd_version new_resource.version
            instance new_resource.instance
            action :create
          end
        end
      end

      # httpd binary symlinks
      link "/usr/sbin/#{apache_name}" do
        to "/usr/sbin/#{http_binary_name}"
        action :create
        not_if { apache_name == 'httpd' }
      end

      # MPM loading
      if new_resource.version.to_f < 2.4
        link "/usr/sbin/#{apache_name}.worker" do
          to '/usr/sbin/httpd.worker'
          action :create
          not_if { apache_name == 'httpd' }
        end

        link "/usr/sbin/#{apache_name}.event" do
          to '/usr/sbin/httpd.event'
          action :create
          not_if { apache_name == 'httpd' }
        end
      else
        httpd_module "mpm_#{new_resource.mpm}" do
          httpd_version new_resource.version
          instance new_resource.instance
          action :create
        end
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

      # configuration directories
      directory "/etc/#{apache_name}" do
        user 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      directory "/etc/#{apache_name}/conf" do
        user 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      directory "/etc/#{apache_name}/conf.d" do
        path "/etc/#{apache_name}/conf.d"
        user 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      directory "/etc/#{apache_name}/conf.modules.d" do
        user 'root'
        group 'root'
        mode '0755'
        recursive true
        only_if { new_resource.version.to_f >= 2.4 }
        action :create
      end

      # support directories
      directory "/usr/#{libarch}/httpd/modules" do
        user 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      directory "/var/log/#{apache_name}" do
        user 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      link "/etc/#{apache_name}/logs" do
        to "../../var/log/#{apache_name}"
        action :create
      end

      link "/etc/#{apache_name}/modules" do
        to "../../usr/#{libarch}/httpd/modules"
        action :create
      end

      # /var/run
      directory "/var/run/#{apache_name}" do
        user 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      link "/etc/#{apache_name}/run" do
        to "../../var/run/#{apache_name}"
        action :create
      end

      # configuration files
      template "/etc/#{apache_name}/conf/mime.types" do
        source 'magic.erb'
        owner 'root'
        group 'root'
        mode '0644'
        cookbook 'httpd'
        action :create
      end

      template "/etc/#{apache_name}/conf/httpd.conf" do
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

      # Install core modules
      new_resource.modules.each do |mod|
        httpd_module mod do
          instance new_resource.instance
          httpd_version new_resource.version
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

      %W(/usr/sbin/#{apache_name}
         /usr/sbin/#{apache_name}.worker
         /usr/sbin/#{apache_name}.event).each do |path|
        link path do
          action :delete
        end
      end

      # configuration directories and logs
      %W(/etc/#{apache_name}
         /var/log/#{apache_name}
         /var/run/#{apache_name}).each do |dir|
        directory dir do
          recursive true
          action :delete
        end
      end
    end

    include HttpdCookbook::Helpers::Rhel
  end
end
