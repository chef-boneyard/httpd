require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Rhel
        class Systemd < Chef::Provider::HttpdService::Rhel
          use_inline_resources if defined?(use_inline_resources)

          def whyrun_supported?
            true
          end

          #
          # LWRP DSL methods
          #
          action :create do
            set_class_variables(node, new_resource)
            create_common
            create_service
          end

          action :delete do
            set_class_variables(node, new_resource)
            delete_common
            delete_service
          end

          action :restart do
            set_class_variables(node, new_resource)

            service "#{new_resource.name} delete #{@@apache_name}" do
              service_name @@apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Systemd
              action :restart
            end
          end

          action :reload do
            set_class_variables(node, new_resource)

            service "#{new_resource.name} reload #{@@apache_name}" do
              service_name @@apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Systemd
              action :reload
            end
          end

          #
          # Function implementats
          #
          def create_service
            httpd_module "#{new_resource.name} create systemd" do
              module_name 'systemd'
              httpd_version @@apache_version
              instance new_resource.instance
              notifies :reload, "service[#{new_resource.name} create #{@@apache_name}]"
              action :create
            end

            directory "#{new_resource.name} create /run/#{@@apache_name}" do
              path "/run/#{@@apache_name}"
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            template "#{new_resource.name} create /usr/lib/systemd/system/#{@@apache_name}.service" do
              path "/usr/lib/systemd/system/#{@@apache_name}.service"
              source 'systemd/httpd.service.erb'
              owner 'root'
              group 'root'
              mode '0644'
              cookbook 'httpd'
              variables(:apache_name => @@apache_name)
              action :create
            end

            directory "#{new_resource.name} create /usr/lib/systemd/system/#{@@apache_name}.service.d" do
              path "/usr/lib/systemd/system/#{@@apache_name}.service.d"
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            service "#{new_resource.name} create #{@@apache_name}" do
              service_name @@apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Systemd
              action [:start, :enable]
            end
          end

          def delete_service
            service "#{new_resource.name} create #{@@apache_name}" do
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Systemd
              action [:stop, :disable]
            end
          end
        end
      end
    end
  end
end
