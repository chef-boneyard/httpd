require 'chef/provider/lwrp_base'
require_relative 'helpers_rhel'

class Chef
  class Provider
    class HttpdService
      class Rhel
        class Sysvinit < Chef::Provider::HttpdService::Rhel
          use_inline_resources if defined?(use_inline_resources)

          include Httpd::Helpers::Rhel

          def whyrun_supported?
            true
          end

          action :restart do
            service "#{new_resource.parsed_name} delete #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Redhat
              action :restart
            end
          end

          action :reload do
            service "#{new_resource.parsed_name} delete #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Redhat
              action :reload
            end
          end

          def create_service
            template "#{new_resource.parsed_name} create /etc/init.d/#{apache_name}" do
              path "/etc/init.d/#{apache_name}"
              source "#{new_resource.parsed_version}/sysvinit/el-#{elversion}/httpd.erb"
              owner 'root'
              group 'root'
              mode '0755'
              variables(apache_name: apache_name)
              cookbook 'httpd'
              action :create
            end

            template "#{new_resource.parsed_name} create /etc/sysconfig/#{apache_name}" do
              path "/etc/sysconfig/#{apache_name}"
              source "rhel/sysconfig/httpd-#{new_resource.parsed_version}.erb"
              owner 'root'
              group 'root'
              mode '0644'
              variables(
                apache_name: apache_name,
                mpm: new_resource.parsed_mpm,
                pid_file: pid_file
                )
              cookbook 'httpd'
              notifies :restart, "service[#{new_resource.parsed_name} create #{apache_name}]"
              action :create
            end

            service "#{new_resource.parsed_name} create #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Redhat
              action [:start, :enable]
            end
          end

          def delete_service
            service "#{new_resource.parsed_name} create #{apache_name}" do
              service_name apache_name
              supports restart: true, reload: true, status: true
              provider Chef::Provider::Service::Init::Redhat
              action [:stop, :disable]
            end
          end
        end
      end
    end
  end
end
