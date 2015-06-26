require 'chef/provider/lwrp_base'
require_relative 'helpers_rhel'

class Chef
  class Provider
    class HttpdService
      class Rhel
        class Systemd < Chef::Provider::HttpdService::Rhel
          # This is Chef-12.0.0 back-compat, it is different from current core chef 12.4.0 declarations
          provides :httpd_service, platform_family: 'rhel'

          def self.provides?(node, resource)
            super && Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
          end

          def self.supports?(resource, action)
            Chef::Platform::ServiceHelpers.config_for_service("httpd-#{resource.instance}").include?(:systemd)
          end

          use_inline_resources

          def whyrun_supported?
            true
          end

          include HttpdCookbook::Helpers
          include HttpdCookbook::Helpers::Rhel

          action :start do
            httpd_module "#{new_resource.name} :create systemd" do
              module_name 'systemd'
              httpd_version parsed_version
              instance new_resource.instance
              notifies :reload, "service[#{new_resource.name} :create #{apache_name}]"
              action :create
            end

            directory "#{new_resource.name} :create /run/#{apache_name}" do
              path "/run/#{apache_name}"
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            template "#{new_resource.name} :create /usr/lib/systemd/system/#{apache_name}.service" do
              path "/usr/lib/systemd/system/#{apache_name}.service"
              source 'systemd/httpd.service.erb'
              owner 'root'
              group 'root'
              mode '0644'
              cookbook 'httpd'
              variables(apache_name: apache_name)
              action :create
            end

            directory "#{new_resource.name} :create /usr/lib/systemd/system/#{apache_name}.service.d" do
              path "/usr/lib/systemd/system/#{apache_name}.service.d"
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            service "#{new_resource.name} :create #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Systemd
              action [:start, :enable]
            end
          end

          action :stop do
            service "#{new_resource.name} :stop #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Systemd
              action :stop
            end
          end

          action :restart do
            service "#{new_resource.name} :restart #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Systemd
              action :restart
            end
          end

          action :reload do
            service "#{new_resource.name} :reload #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Systemd
              action :reload
            end
          end

          def create_stop_system_service
            service "#{new_resource.name} :create httpd" do
              service_name 'httpd'
              provider Chef::Provider::Service::Init::Systemd
              action [:stop, :disable]
            end
          end

          def delete_stop_service
            service "#{new_resource.name} :delete #{apache_name}" do
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Systemd
              action [:stop, :disable]
            end
          end
        end
      end
    end
  end
end
