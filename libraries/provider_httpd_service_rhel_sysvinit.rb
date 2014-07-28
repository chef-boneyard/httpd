require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Rhel
        class Sysvinit < Chef::Provider::HttpdService::Rhel
          use_inline_resources if defined?(use_inline_resources)

          def whyrun_supported?
            true
          end

          def action_restart
            # support multiple instances
            new_resource.instance == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.instance}"

            service "#{new_resource.name} delete #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Redhat
              action :restart
            end
          end

          def action_reload
            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

            service "#{new_resource.name} delete #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Redhat
              action :reload
            end
          end

          def create_service
            # support multiple instances
            new_resource.instance == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.instance}"

            # enterprise linux version calculation
            case node['platform_version'].to_i
            when 5
              elversion = 5
            when 6
              elversion = 6
            when 7
              elversion = 7
            when 2013
              elversion = 6
            when 2014
              elversion = 6
            end

            # PID file
            case elversion
            when 5
              pid_file = "/var/run/#{apache_name}.pid"
            when 6
              pid_file = "/var/run/#{apache_name}/httpd.pid"
            when 7
              pid_file = "/var/run/#{apache_name}/httpd.pid"
            end
            
            #
            # Sysvinit
            #
            # init script
            template "#{new_resource.name} create /etc/init.d/#{apache_name}" do
              path "/etc/init.d/#{apache_name}"
              source "#{new_resource.version}/sysvinit/el-#{elversion}/httpd.erb"
              owner 'root'
              group 'root'
              mode '0755'
              variables(:apache_name => apache_name)
              cookbook 'httpd'
              action :create
            end

            # init script configuration
            template "#{new_resource.name} create /etc/sysconfig/#{apache_name}" do
              path "/etc/sysconfig/#{apache_name}"
              source "rhel/sysconfig/httpd-#{new_resource.version}.erb"
              owner 'root'
              group 'root'
              mode '0644'
              variables(
                :apache_name => apache_name,
                :mpm => new_resource.mpm,
                :pid_file => pid_file
                )
              cookbook 'httpd'
              notifies :restart, "service[#{new_resource.name} create #{apache_name}]"
              action :create
            end

            # service management
            service "#{new_resource.name} create #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Redhat
              action [:start, :enable]
            end
          end

          def delete_service
            # support multiple instances
            new_resource.instance == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.instance}"

            # enterprise linux version calculation
            case node['platform_version'].to_i
            when 5
              elversion = 5
            when 6
              elversion = 6
            when 7
              elversion = 7
            when 2013
              elversion = 6
            when 2014
              elversion = 6
            end

            service "#{new_resource.name} create #{apache_name}" do
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Redhat
              action [:stop, :disable]
            end

            link "#{new_resource.name} delete /usr/sbin/#{apache_name}" do
              target_file "/usr/sbin/#{apache_name}"
              action :delete
              not_if { apache_name == 'httpd' }
            end

            # MPM loading
            if new_resource.version.to_f < 2.4
              link "#{new_resource.name} delete /usr/sbin/#{apache_name}.worker" do
                target_file "/usr/sbin/#{apache_name}.worker"
                action :delete
                not_if { apache_name == 'httpd' }
              end

              link "#{new_resource.name} delete /usr/sbin/#{apache_name}.event" do
                target_file "/usr/sbin/#{apache_name}.event"
                action :delete
                not_if { apache_name == 'httpd' }
              end
            end

            # configuration directories
            directory "#{new_resource.name} delete /etc/#{apache_name}" do
              path "/etc/#{apache_name}"
              recursive true
              action :delete
            end

            # logs
            directory "#{new_resource.name} delete /var/log/#{apache_name}" do
              path "/var/log/#{apache_name}"
              recursive true
              action :delete
            end

            # /var/run
            if elversion > 5
              directory "#{new_resource.name} delete /var/run/#{apache_name}" do
                path "/var/run/#{apache_name}"
                recursive true
                action :delete
              end

              link "#{new_resource.name} delete /etc/#{apache_name}/run" do
                target_file "/etc/#{apache_name}/run"
                action :delete
              end
            else
              link "#{new_resource.name} delete /etc/#{apache_name}/run" do
                target_file "/etc/#{apache_name}/run"
                action :delete
              end
            end
          end
        end
      end
    end
  end
end
