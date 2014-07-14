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

          action :create do            
            #
            # local variables
            #
            case node['kernel']['machine']
            when 'x86_64'
              libarch = 'lib64'
            when 'i686'
              libarch = 'lib'
            end

            # enterprise linux version calculation
            case node['platform_version'].to_i
            when 5
              elversion = 5
            when 6
              elversion = 6
            when 2013
              elversion = 6
            when 2014
              elversion = 6
            end

            # version
            apache_version = new_resource.version

            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

            # PID file
            case elversion
            when 5
              pid_file = "/var/run/#{apache_name}.pid"
            when 6
              pid_file = "/var/run/#{apache_name}/httpd.pid"
            end

            # lock file
            lock_file = "/var/lock/subsys/#{apache_name}"

            # apache 2.2 and 2.4 differences
            if apache_version.to_f < 2.4
              lock_file = "/var/lock/subsys/#{apache_name}"
              mutex = nil
            else
              lock_file = nil
              mutex = "file:/var/lock/subsys/#{apache_name} default"
            end

            # Include directories for additional configurtions
            if apache_version.to_f < 2.4
              includes = [
                'conf.d/*.conf',
                'conf.d/*.load'
              ]
            else
              include_optionals = [
                'conf.d/*.conf',
                'conf.modules.d/*.conf',
                'conf.modules.d/*.load'
              ]
            end

            #
            # Chef Resources
            #            
            httpd_module 'systemd' do
              action :create
            end

            directory "#{new_resource.name} create /run/#{apache_name}" do
              path "/run/#{apache_name}"
              owner 'root'
              group 'apache'
              mode '0710'
              action :create
            end

            template "#{new_resource} create /usr/lib/systemd/system/#{apache_name}.service" do
              path "/usr/lib/systemd/system/#{apache_name}.service"
              source "#{apache_version}/systemd/#{node['platform']}/#{node['platform_version']}/httpd.service.erb"
              owner 'root'
              group 'root'
              mode '0644'
              cookbook 'httpd'
              variables(:apache_name => apache_name)
              action :create
            end

            directory "#{new_resource} create /usr/lib/systemd/system/#{apache_name}.service.d" do
              path "/usr/lib/systemd/system/#{apache_name}.service.d"
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            service "#{new_resource.name} create #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Systemd
              action [:start, :enable]
            end
          end

          action :delete do
            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

            service "#{new_resource.name} create #{apache_name}" do
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Systemd
              action [:stop, :disable]
            end
          end

          action :restart do
            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

            service "#{new_resource.name} delete #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Systemd
              action :restart
            end
          end

          action :reload do
            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

            service "#{new_resource.name} delete #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Systemd
              action :reload
            end
          end
        end
      end
    end
  end
end
