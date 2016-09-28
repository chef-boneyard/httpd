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
      package package_name do
        action :install
      end

      # Defined in subclass
      create_stop_system_service

      # achieve parity with modules statically compiled into
      # debian and ubuntu
      if version.to_f < 2.4
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
      if version.to_f < 2.4
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
        httpd_module "mpm_#{mpm}" do
          httpd_version new_resource.version
          instance new_resource.instance
          action :create
        end
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
      if elversion > 5
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
      else
        link "/etc/#{apache_name}/run" do
          to '../../var/run'
          action :create
        end
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
          run_group: run_group,
          run_user: run_user,
          server_root: "/etc/#{apache_name}",
          servername: servername
        )
        cookbook 'httpd'
        action :create
      end

      # Install core modules
      modules.each do |mod|
        httpd_module mod do
          instance new_resource.instance
          httpd_version new_resource.version
          action :create
        end
      end
    end

    action :delete do
      delete_stop_service

      link "/usr/sbin/#{apache_name}" do
        to '/usr/sbin/httpd'
        action :delete
        not_if { apache_name == 'httpd' }
      end

      # MPM loading
      if version.to_f < 2.4
        link "/usr/sbin/#{apache_name}.worker" do
          to '/usr/sbin/httpd.worker'
          action :delete
          not_if { apache_name == 'httpd' }
        end

        link "/usr/sbin/#{apache_name}.event" do
          to '/usr/sbin/httpd.event'
          action :delete
          not_if { apache_name == 'httpd' }
        end
      end

      # configuration directories and logs
      %w( /etc/#{apache_name} /var/log/#{apache_name} ).each do |dir|
        directory dir do
          owner 'root'
          group 'root'
          mode '0755'
          recursive true
          action :delete
        end
      end

      # /var/run
      directory "/var/run/#{apache_name}" do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        only_if { elversion > 5 }
        action :delete
      end

      link "/etc/#{apache_name}/run" do
        action :delete
      end
    end

    include HttpdCookbook::Helpers::Rhel
  end
end
