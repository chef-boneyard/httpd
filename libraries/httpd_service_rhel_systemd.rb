module HttpdCookbook
  class HttpdServiceRhelSystemd < HttpdServiceRhel
    use_automatic_resource_name

    provides :httpd_service, platform_family: %w(rhel fedora suse) do
      Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
    end

    action :start do
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

    action_class do
      def create_stop_system_service
        service apache_name do
          provider Chef::Provider::Service::Init::Systemd
          action [:stop, :disable]
        end
      end

      def create_setup_service
        httpd_module 'systemd' do
          httpd_version new_resource.version
          instance new_resource.instance
          notifies :reload, "service[#{apache_name}]"
          action :create
        end

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
            binary_name: apache_name,
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
            run_user: new_resource.run_user,
            run_group: new_resource.run_group
          )
        end

        service apache_name do
          supports restart: true, reload: true, status: true
          provider Chef::Provider::Service::Init::Systemd
          action :nothing
        end
      end

      def delete_stop_service
        service apache_name do
          supports restart: true, reload: true, status: true
          provider Chef::Provider::Service::Init::Systemd
          action [:stop, :disable]
        end

        %W(/etc/systemd/system/#{apache_name}.service.d
           /run/#{apache_name}).each do |path|
          directory path do
            recursive true
            action :delete
          end
        end

        %W(/usr/lib/tmpfiles.d/#{apache_name}.conf
           /etc/systemd/system/#{apache_name}.service).each do |path|
          file path do
            action :delete
          end
        end
      end
    end
  end
end
