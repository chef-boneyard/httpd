require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Fedora < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'fedora pattern' do
            #
            # local variables
            #
            case node['kernel']['machine']
            when 'x86_64'
              libarch = 'lib64'
            when 'i686'
              libarch = 'lib'
            end

            # version
            apache_version = new_resource.version

            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

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
              link_type :hard
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

            directory "#{new_resource.name} create /etc/#{apache_name}/conf.modules.d" do
              path "/etc/#{apache_name}/conf.modules.d"
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
              to "../../usr/#{libarch}/httpd/modules"
              action :create
            end

            # /var/run
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

            link "#{new_resource.name} create /etc/httpd/conf/mime.types" do
              target_file "/etc/#{apache_name}/conf/mime.types"
              to '/etc/mime.types'
              action :create
            end

            template "#{new_resource.name} create /etc/#{apache_name}/conf/httpd.conf" do
              path "/etc/#{apache_name}/conf/httpd.conf"
              source "#{apache_version}/httpd-systemd.conf.erb"
              owner 'root'
              group 'root'
              mode '0644'
              variables(
                :config => new_resource,
                :pid_file => "/var/run/#{apache_name}/httpd.pid",
                :apache_name => apache_name
                )
              cookbook 'httpd'
              notifies :restart, "service[#{new_resource.name} create #{apache_name}]"
              action :create
            end

            # mpm configuration
            httpd_module new_resource.mpm do
              action :create
            end

            # FIXME: better location for template source?
            template "#{new_resource.name} create /etc/#{apache_name}/mods-available/mpm_#{new_resource.mpm}.conf" do
              path "/etc/#{apache_name}/conf.modules.d/mpm_#{new_resource.mpm}.conf"
              source "#{new_resource.version}/mods/rhel/mpm.conf.erb"
              owner 'root'
              group 'root'
              mode '0644'
              cookbook 'httpd'
              variables(
                :mpm => new_resource.mpm,
                :startservers => new_resource.startservers,
                :minspareservers => new_resource.minspareservers,
                :maxspareservers => new_resource.maxspareservers,
                :maxclients => new_resource.maxclients,
                :maxrequestsperchild => new_resource.maxrequestsperchild,
                :minsparethreads => new_resource.minsparethreads,
                :maxsparethreads => new_resource.maxsparethreads,
                :threadlimit => new_resource.threadlimit,
                :threadsperchild => new_resource.threadsperchild,
                :maxrequestworkers => new_resource.maxrequestworkers,
                :maxconnectionsperchild => new_resource.maxconnectionsperchild
                )
              action :create
            end

            # Modules
            %w( log_config logio unixd
                version watchdog
            ).each do |m|
              httpd_module m do
                httpd_version apache_version
                httpd_instance apache_name
                action :create
              end
            end

            # systemd
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

            # service management
            service "#{new_resource.name} create #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Systemd
              action [:start, :enable]
            end
          end
        end

        action :delete do
          converge_by 'fedora pattern' do
            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

            service "#{new_resource.name} delete #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Systemd
              action [:stop, :disable]
            end

            directory "#{new_resource.name} delete /etc/#{apache_name}" do
              path "/etc/#{apache_name}"
              recursive true
              action :delete
            end
          end
        end

        action :restart do
          converge_by 'fedora pattern' do
            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

            service "#{new_resource.name} restart #{apache_name}" do
              service_name apache_name
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Systemd
              action :restart
            end
          end
        end

        action :reload do
          converge_by 'fedora pattern' do
            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

            service "#{new_resource.name} reload #{apache_name}" do
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

Chef::Platform.set :platform => :fedora, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Fedora
