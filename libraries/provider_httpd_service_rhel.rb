require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Rhel < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'rhel pattern' do
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
              elversion = 5
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

            #
            # Chef resources
            #

            # software installation
            package "#{new_resource.name} create #{new_resource.package_name}" do
              package_name new_resource.package_name
              notifies :run, "execute[#{new_resource.name} create remove_package_config]", :immediately
              action :install
            end

            execute "#{new_resource.name} create remove_package_config" do
              user 'root'
              command "rm -f /etc/#{apache_name}/conf.d/*"
              only_if "test -f /etc/#{apache_name}/conf.d/README"
              action :nothing
            end

            # httpd binary symlinks
            link "#{new_resource.name} create /usr/sbin/#{apache_name}" do
              target_file "/usr/sbin/#{apache_name}"
              to '/usr/sbin/httpd'
              action :create
              not_if { apache_name == 'httpd' }
            end

            link "#{new_resource.name} create /usr/sbin/#{apache_name}.worker" do
              target_file "/usr/sbin/#{apache_name}.worker"
              to '/usr/sbin/httpd.worker'
              action :create
              not_if { apache_name == 'httpd' }
            end

            link "#{new_resource.name} create /usr/sbin/#{apache_name}.event" do
              target_file "/usr/sbin/#{apache_name}.event"
              to '/usr/sbin/httpd.event'
              action :create
              not_if { apache_name == 'httpd' }
            end

            # configuration directories
            directory "#{new_resource.name} create /etc/#{apache_name}" do
              path "/etc/#{apache_name}"
              user 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            directory "#{new_resource.name} create /etc/#{apache_name}/conf" do
              path "/etc/#{apache_name}/conf"
              user 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            directory "#{new_resource.name} create /etc/#{apache_name}/conf.d" do
              path "/etc/#{apache_name}/conf.d"
              user 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            # support directories
            directory "#{new_resource.name} create /var/log/#{apache_name}" do
              path "/var/log/#{apache_name}"
              user 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            directory "#{new_resource.name} create /usr/#{libarch}/httpd/modules" do
              path "/usr/#{libarch}/httpd/modules"
              user 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            link "#{new_resource.name} create /etc/#{apache_name}/logs" do
              target_file "/etc/#{apache_name}/logs"
              to "../../var/log/#{apache_name}"
              action :create
            end

            link "#{new_resource.name} create /etc/#{apache_name}/modules" do
              target_file "/etc/#{apache_name}/modules"
              to "../../usr/lib64/#{apache_name}/modules"
              action :create
            end

            # /var/run
            if elversion > 5
              directory "#{new_resource.name} create /var/run/#{apache_name}" do
                path "/var/run/#{apache_name}"
                user 'root'
                group 'root'
                mode '0755'
                recursive true
                action :create
              end

              link "#{new_resource.name} create /etc/#{apache_name}/run" do
                target_file "/etc/#{apache_name}/run"
                to "../../var/run/#{apache_name}"
                action :create
              end
            else
              link "#{new_resource.name} create /etc/#{apache_name}/run" do
                target_file "/etc/#{apache_name}/run"
                to '../../var/run/'
                action :create
              end
            end

            # configuration files
            template "#{new_resource.name} create /etc/#{apache_name}/conf/magic" do
              path "/etc/#{apache_name}/conf/magic"
              source "#{apache_version}/magic.erb"
              owner 'root'
              group 'root'
              mode '0644'
              cookbook 'httpd'
              action :create
            end

            template "#{new_resource.name} create /etc/#{apache_name}/conf/httpd.conf" do
              path "/etc/#{apache_name}/conf/httpd.conf"
              source "#{apache_version}/httpd.conf.erb"
              owner 'root'
              group 'root'
              mode '0644'
              variables(
                :config => new_resource,
                :apache_name => apache_name,
                :pid_file => pid_file
                )
              cookbook 'httpd'
              notifies :restart, "service[#{new_resource.name} create #{apache_name}]"
              action :create
            end

            # mpm selection
            template "#{new_resource.name} create /etc/sysconfig/#{apache_name}" do
              path "/etc/sysconfig/#{apache_name}"
              source "#{apache_version}/rhel/sysconfig/httpd.erb"
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

            # init script
            template "#{new_resource.name} create /etc/rc.d/init.d/#{apache_name}" do
              path "/etc/init.d/#{apache_name}"
              source "#{apache_version}/sysvinit/el-#{elversion}/httpd.erb"
              owner 'root'
              group 'root'
              mode '0755'
              variables(:apache_name => apache_name)
              cookbook 'httpd'
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
        end

        action :delete do
          converge_by 'rhel pattern' do
            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

            service "#{new_resource.name} delete #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Redhat
              action [:stop, :disable]
            end
            # moar resources here
          end
        end

        action :restart do
          converge_by 'rhel pattern' do
            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

            service "#{new_resource.name} delete #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Redhat
              action :restart
            end
          end
        end

        action :reload do
          converge_by 'rhel pattern' do
            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

            service "#{new_resource.name} delete #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Redhat
              action :reload
            end
          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :amazon, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel
Chef::Platform.set :platform => :redhat, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel
Chef::Platform.set :platform => :centos, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel
Chef::Platform.set :platform => :oracle, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel
Chef::Platform.set :platform => :scientific, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel
