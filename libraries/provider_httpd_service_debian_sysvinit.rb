require 'chef/provider/lwrp_base'
require_relative 'helpers_debian'

class Chef
  class Provider
    class HttpdService
      class Debian < Chef::Provider::HttpdService
        class Sysvinit < Chef::Provider::HttpdService::Debian
          use_inline_resources if defined?(use_inline_resources)

          include Httpd::Helpers::Debian

          def whyrun_supported?
            true
          end

          def action_restart
            service "#{new_resource.parsed_name} restart #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Debian
              action :restart
            end
          end

          def action_reload
            service "#{new_resource.parsed_name} reload #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Debian
              action :reload
            end
          end

          def create_service
            # init script
            template "#{new_resource.parsed_name} create /etc/init.d/#{apache_name}" do
              path "/etc/init.d/#{apache_name}"
              source "#{apache_version}/sysvinit/#{platform_and_version}/apache2.erb"
              owner 'root'
              group 'root'
              mode '0755'
              variables(:apache_name => apache_name)
              cookbook 'httpd'
              action :create
            end

            # service management
            service "#{new_resource.parsed_name} create #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Debian
              action [:start, :enable]
            end
          end

          def delete_service
            # Software installation: This is needed to supply the init
            # script that powers the service facility.
            package "#{new_resource.parsed_name} delete #{new_resource.parsed_package_name}" do
              package_name new_resource.parsed_package_name
              notifies :run, "bash[#{new_resource.parsed_name} delete remove_package_config]", :immediately
              action :install
            end

            bash "#{new_resource.parsed_name} delete remove_package_config" do
              user 'root'
              code <<-EOH
              for i in `ls /etc/apache2 | egrep -v "envvars|apache2.conf"` ; do rm -rf /etc/apache2/$i ; done
              EOH
              action :nothing
            end

            service "#{new_resource.parsed_name} delete #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Debian
              action [:disable, :stop]
            end
          end
        end
      end
    end
  end
end
