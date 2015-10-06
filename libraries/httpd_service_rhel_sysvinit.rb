module HttpdCookbook
  class HttpdServiceRhelSysvinit < HttpdServiceRhel
    use_automatic_resource_name
    # This is Chef-12.0.0 back-compat, it is different from current core chef 12.4.0 declarations
    if defined?(provides)
      provides :httpd_service, platform_family: %w(rhel fedora suse) do
        Chef::Platform::ServiceHelpers.service_resource_providers.include?(:redhat)
      end
    end

    action :start do
      template "#{name} :create /etc/init.d/#{apache_name}" do
        path "/etc/init.d/#{apache_name}"
        source "#{parsed_version}/sysvinit/el-#{elversion}/httpd.erb"
        owner 'root'
        group 'root'
        mode '0755'
        variables(apache_name: apache_name)
        cookbook 'httpd'
        action :create
      end

      template "#{name} :create /etc/sysconfig/#{apache_name}" do
        path "/etc/sysconfig/#{apache_name}"
        source "rhel/sysconfig/httpd-#{parsed_version}.erb"
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          apache_name: apache_name,
          mpm: parsed_mpm,
          pid_file: pid_file
        )
        cookbook 'httpd'
        notifies :restart, "service[#{new_resource.name} :create #{apache_name}]"
        action :create
      end

      service "#{name} :create #{apache_name}" do
        service_name apache_name
        supports status: true
        provider Chef::Provider::Service::Init::Redhat
        action [:start, :enable]
      end
    end

    action :stop do
      service "#{name} delete #{apache_name}" do
        service_name apache_name
        supports status: true
        provider Chef::Provider::Service::Init::Redhat
        action :stop
      end
    end

    action :restart do
      service "#{name} delete #{apache_name}" do
        service_name apache_name
        supports restart: true
        provider Chef::Provider::Service::Init::Redhat
        action :restart
      end
    end

    action :reload do
      service "#{name} delete #{apache_name}" do
        service_name apache_name
        supports reload: true
        provider Chef::Provider::Service::Init::Redhat
        action :reload
      end
    end

    action_class.class_eval do
      def create_stop_system_service
        service "#{name} :create httpd" do
          service_name 'httpd'
          supports status: true
          provider Chef::Provider::Service::Init::Redhat
          action [:stop, :disable]
        end
      end

      def delete_stop_service
        service "#{name} :delete #{apache_name}" do
          service_name apache_name
          supports status: true
          provider Chef::Provider::Service::Init::Redhat
          action [:stop, :disable]
        end
      end
    end
  end
end
