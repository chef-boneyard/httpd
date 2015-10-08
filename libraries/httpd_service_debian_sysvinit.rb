module HttpdCookbook
  class HttpdServiceDebianSysvinit < HttpdServiceDebian
    use_automatic_resource_name
    provides :httpd_service, platform_family: 'debian'

    action :start do
      # init script
      template "#{name} :create /etc/init.d/#{apache_name}" do
        path "/etc/init.d/#{apache_name}"
        source "#{apache_version}/sysvinit/#{platform_and_version}/apache2.erb"
        owner 'root'
        group 'root'
        mode '0755'
        variables(apache_name: apache_name)
        cookbook 'httpd'
        action :create
      end

      # service management
      service "#{name} :create #{apache_name}" do
        service_name apache_name
        supports restart: true, reload: true, status: true
        provider Chef::Provider::Service::Init::Debian
        action [:start, :enable]
      end
    end

    action :stop do
      service "#{name} :stop #{apache_name}" do
        service_name apache_name
        supports restart: true, reload: true, status: true
        provider Chef::Provider::Service::Init::Debian
        action :stop
      end
    end

    action :restart do
      service "#{name} :restart #{apache_name}" do
        service_name apache_name
        supports restart: true, reload: true, status: true
        provider Chef::Provider::Service::Init::Debian
        action :restart
      end
    end

    action :reload do
      service "#{name} :reload #{apache_name}" do
        service_name apache_name
        supports restart: true, reload: true, status: true
        provider Chef::Provider::Service::Init::Debian
        action :reload
      end
    end

    action_class.class_eval do
      def create_stop_system_service
        service "#{name} :create apache2" do
          service_name 'apache2'
          provider Chef::Provider::Service::Init::Debian
          supports restart: true, status: true
          action [:stop, :disable]
        end
      end

      def delete_stop_service
        # Software installation: This is needed to supply the init
        # script that powers the service facility.
        # package "#{name} :delete #{package_name}" do
        #   package_name package_name
        #   action :install
        # end

        # init script
        template "#{name} :create /etc/init.d/#{apache_name}" do
          path "/etc/init.d/#{apache_name}"
          source "#{apache_version}/sysvinit/#{platform_and_version}/apache2.erb"
          owner 'root'
          group 'root'
          mode '0755'
          variables(apache_name: apache_name)
          cookbook 'httpd'
          action :create
        end

        service "#{name} :delete #{apache_name}" do
          service_name apache_name
          supports restart: true, reload: true, status: true
          provider Chef::Provider::Service::Init::Debian
          action [:disable, :stop]
        end
      end
    end
  end
end
