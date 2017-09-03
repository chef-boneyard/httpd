module HttpdCookbook
  class HttpdServiceDebianSysvinit < HttpdServiceDebian
    use_automatic_resource_name
    provides :httpd_service, platform_family: 'debian'

    action :start do
      # service management
      service apache_name do
        supports restart: true, reload: true, status: true
        provider Chef::Provider::Service::Init::Debian
        action [:start, :enable]
      end
    end

    action :stop do
      service apache_name do
        supports restart: true, reload: true, status: true
        provider Chef::Provider::Service::Init::Debian
        action :stop
      end
    end

    action :restart do
      service apache_name do
        supports restart: true, reload: true, status: true
        provider Chef::Provider::Service::Init::Debian
        action :restart
      end
    end

    action :reload do
      service apache_name do
        supports restart: true, reload: true, status: true
        provider Chef::Provider::Service::Init::Debian
        action :reload
      end
    end

    action_class do
      def create_stop_system_service
        service 'apache2' do
          provider Chef::Provider::Service::Init::Debian
          supports restart: true, status: true
          action [:stop, :disable]
        end
      end

      def create_setup_service
        # init script
        template "/etc/init.d/#{apache_name}" do
          source "#{apache_version}/sysvinit/#{platform_and_version}/apache2.erb"
          owner 'root'
          group 'root'
          mode '0755'
          variables(apache_name: apache_name)
          cookbook 'httpd'
          action :create
        end
      end

      def delete_stop_service
        service apache_name do
          supports restart: true, reload: true, status: true
          provider Chef::Provider::Service::Init::Debian
          only_if { ::File.exist?("/etc/init.d/#{apache_name}") }
          action [:disable, :stop]
        end

        file "/etc/init.d/#{apache_name}" do
          action :delete
        end
      end
    end
  end
end
