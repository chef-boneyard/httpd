require 'chef/provider/lwrp_base'
require_relative 'helpers_debian'

class Chef
  class Provider
    class HttpdService
      class Debian < Chef::Provider::HttpdService
        class Sysvinit < Chef::Provider::HttpdService::Debian
          use_inline_resources if defined?(use_inline_resources)

          def whyrun_supported?
            true
          end

          include HttpdCookbook::Helpers
          include HttpdCookbook::Helpers::Debian

          action :start do
            # init script
            template "#{new_resource.name} :create /etc/init.d/#{apache_name}" do
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
            service "#{new_resource.name} :create #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Debian
              action [:start, :enable]
            end
          end

          action :stop do
            service "#{new_resource.name} :stop #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Debian
              action :stop
            end
          end

          action :restart do
            service "#{new_resource.name} :restart #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Debian
              action :restart
            end
          end

          action :reload do
            service "#{new_resource.name} :reload #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Debian
              action :reload
            end
          end

          def create_stop_system_service
            service "#{new_resource.name} :create apache2" do
              service_name 'apache2'
              provider Chef::Provider::Service::Init::Debian
              supports restart: true, status: true
              action [:stop, :disable]
            end
          end

          def delete_stop_service
            # Software installation: This is needed to supply the init
            # script that powers the service facility.
            package "#{new_resource.name} :delete #{parsed_service_package_name}" do
              package_name parsed_service_package_name
              action :install
            end

            service "#{new_resource.name} :delete #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Debian
              action [:disable, :stop]
            end
          end
        end
      end
    end
  end
end
