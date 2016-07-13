module HttpdCookbook
  class HttpdServiceDebianSystemd < HttpdServiceDebian
    use_automatic_resource_name
    # This is Chef-12.0.0 back-compat, it is different from current
    # core chef 12.4.0 declarations
    if defined?(provides)
      provides :httpd_service, platform_family: %w(debian) do
        Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
      end
    end

    action :start do
      directory "/run/#{apache_name}" do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      template "/etc/systemd/system/#{apache_name}.service" do
        source 'systemd/httpd.service.erb'
        owner 'root'
        group 'root'
        mode '0644'
        cookbook 'httpd'
        variables(
          binary_name: 'apache2',
          apache_name: apache_name,
          config_relative_path: config_file_relative_path
        )
        action :create
      end

      directory "/etc/systemd/system/#{apache_name}.service.d" do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      template "/usr/lib/tmpfiles.d/#{apache_name}.conf" do
        source 'systemd/httpd.conf.erb'
        owner 'root'
        group 'root'
        mode '0644'
        cookbook 'httpd'
        variables(
          apache_name: apache_name,
          run_user: run_user,
          run_group: run_group
        )
      end

      service apache_name do
        supports restart: true, reload: true, status: true
        provider Chef::Provider::Service::Init::Systemd
        action [:start, :enable]
      end
    end

    action :stop do
      service apache_name do
        supports restart: true, reload: true, status: true
        provider Chef::Provider::Service::Init::Systemd
        action :stop
      end
    end

    action :restart do
      service apache_name do
        supports restart: true, reload: true, status: true
        provider Chef::Provider::Service::Init::Systemd
        action :restart
      end
    end

    action :reload do
      service apache_name do
        supports restart: true, reload: true, status: true
        provider Chef::Provider::Service::Init::Systemd
        action :reload
      end
    end

    action_class.class_eval do
      def create_stop_system_service
        service 'apache2' do
          provider Chef::Provider::Service::Init::Systemd
          action [:stop, :disable]
        end
      end

      def delete_stop_service
        service apache_name do
          supports restart: true, reload: true, status: true
          provider Chef::Provider::Service::Init::Systemd
          action [:stop, :disable]
        end
      end
    end
  end
end
