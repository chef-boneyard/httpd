module HttpdCookbook
  class HttpdServiceRhelSysvinit < HttpdServiceRhel
    use_automatic_resource_name

    provides :httpd_service, platform_family: %w(rhel fedora suse amazon) do
      Chef::Platform::ServiceHelpers.service_resource_providers.include?(:redhat)
    end

    action :start do
      service apache_name do
        supports status: true
        provider Chef::Provider::Service::Init::Redhat
        action [:start, :enable]
      end
    end

    action :stop do
      service apache_name do
        supports status: true
        provider Chef::Provider::Service::Init::Redhat
        action :stop
      end
    end

    action :restart do
      service apache_name do
        supports restart: true
        provider Chef::Provider::Service::Init::Redhat
        action :restart
      end
    end

    action :reload do
      service apache_name do
        supports reload: true
        provider Chef::Provider::Service::Init::Redhat
        action :reload
      end
    end

    action_class do
      def create_stop_system_service
        service 'httpd' do
          supports status: true
          provider Chef::Provider::Service::Init::Redhat
          action [:stop, :disable]
        end
      end

      def create_setup_service
        template "/etc/init.d/#{apache_name}" do
          source "#{new_resource.version}/sysvinit/el-#{elversion}/httpd.erb"
          owner 'root'
          group 'root'
          mode '0755'
          variables(apache_name: apache_name)
          cookbook 'httpd'
          action :create
        end

        template "/etc/sysconfig/#{apache_name}" do
          source "rhel/sysconfig/httpd-#{new_resource.version}.erb"
          owner 'root'
          group 'root'
          mode '0644'
          variables(
            apache_name: apache_name,
            mpm: new_resource.mpm,
            pid_file: pid_file
          )
          cookbook 'httpd'
          notifies :restart, "service[#{apache_name}]"
          action :create
        end

        service apache_name do
          supports status: true, restart: true
          restart_command "/sbin/service #{apache_name} condrestart"
          provider Chef::Provider::Service::Init::Redhat
          action :nothing
        end
      end

      def delete_stop_service
        service apache_name do
          supports status: true
          provider Chef::Provider::Service::Init::Redhat
          only_if { ::File.exist?("/etc/init.d/#{apache_name}") }
          action [:stop, :disable]
        end

        %W(/etc/init.d/#{apache_name}
           /etc/sysconfig/#{apache_name}).each do |path|
          file path do
            action :delete
          end
        end
      end
    end
  end
end
