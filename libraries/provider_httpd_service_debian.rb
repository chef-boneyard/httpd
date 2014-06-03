require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Debian < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'debian pattern' do
            # local variables
            apache_version = new_resource.version

            # support multiple instances
            new_resource.name == 'default' ? apache_name = 'apache2' : apache_name = "apache2-#{new_resource.name}"
            new_resource.name == 'default' ? a2enmod_name = 'a2enmod' : a2enmod_name = "a2enmod-#{new_resource.name}"
            new_resource.name == 'default' ? a2dismod_name = 'a2dismod' : a2dismod_name = "a2dismod-#{new_resource.name}"
            new_resource.name == 'default' ? a2ensite_name = 'a2ensite' : a2ensite_name = "a2ensite-#{new_resource.name}"
            new_resource.name == 'default' ? a2dissite_name = 'a2dissite' : a2dissite_name = "a2dissite-#{new_resource.name}"

            # software installation
            package new_resource.package_name do
              action :install
            end

            # support directories
            directory "/var/cache/#{apache_name}" do
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "/var/log/#{apache_name}" do
              owner 'root'
              group 'adm'
              mode '0755'
              action :create
            end

            directory "/var/run/#{apache_name}" do
              owner 'root'
              group 'adm'
              mode '0755'
              action :create
            end

            # configuration directories
            directory "/etc/#{apache_name}" do
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            if apache_version.to_f < 2.4
              directory "/etc/#{apache_name}/conf.d" do
                owner 'root'
                group 'root'
                mode '0755'
                action :create
              end
            else
              directory "/etc/#{apache_name}/conf-available" do
                owner 'root'
                group 'root'
                mode '0755'
                action :create
              end

              directory "/etc/#{apache_name}/conf-enabled" do
                owner 'root'
                group 'root'
                mode '0755'
                action :create
              end
            end

            directory "/etc/#{apache_name}/mods-available" do
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "/etc/#{apache_name}/mods-enabled" do
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "/etc/#{apache_name}/sites-available" do
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "/etc/#{apache_name}/sites-enabled" do
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            # envvars
            template "/etc/#{apache_name}/envvars" do
              source "#{apache_version}/envvars.erb"
              owner 'root'
              group 'root'
              mode '0644'
              variables(
                :run_user => new_resource.run_user,
                :run_group => new_resource.run_group
                )
              cookbook 'httpd'
              action :create
            end

            # utility scripts
            template '/usr/sbin/a2enmod' do
              source "#{apache_version}/scripts/a2enmod.erb"
              owner 'root'
              group 'root'
              mode '0755'
              cookbook 'httpd'
              action :create
            end

            link "/usr/sbin/#{a2enmod_name}" do
              to '/usr/sbin/a2enmod'
              owner 'root'
              group 'root'
              action :create
            end

            link "/usr/sbin/#{a2dismod_name}" do
              to '/usr/sbin/a2enmod'
              owner 'root'
              group 'root'
              action :create
            end

            link "/usr/sbin/#{a2ensite_name}" do
              to '/usr/sbin/a2enmod'
              owner 'root'
              group 'root'
              action :create
            end

            link "/usr/sbin/#{a2dissite_name}" do
              to '/usr/sbin/a2enmod'
              owner 'root'
              group 'root'
              action :create
            end

            # init script
            template "/etc/init.d/#{apache_name}" do
              source "#{apache_version}/sysvinit/apache2.erb"
              owner 'root'
              group 'root'
              mode '0755'
              variables(:apache_name => apache_name)
              cookbook 'httpd'
              action :create
            end

            # main configuration file
            template "/etc/#{apache_name}/apache2.conf" do
              source "#{apache_version}/apache2.conf.erb"
              owner 'root'
              group 'root'
              mode '0644'
              variables(
                :config => new_resource,
                :apache_name => apache_name
                )
              cookbook 'httpd'
              action :create
            end

            # service management
            service apache_name do
              action [:start, :enable]
              provider Chef::Provider::Service::Init::Debian
            end
          end
        end

        action :restart do
          new_resource.name == 'default' ? apache_name = 'apache2' : apache_name = "apache2-#{new_resource.name}"
          converge_by 'debian pattern' do
            service apache_name do
              provider Chef::Provider::Service::Init::Debian
              supports :restart => true
              action :restart
            end
          end
        end

        action :reload do
          new_resource.name == 'default' ? apache_name = 'apache2' : apache_name = "apache2-#{new_resource.name}"
          converge_by 'debian pattern' do
            service apache_name do
              provider Chef::Provider::Service::Init::Debian
              supports :reload => true
              action :reload
            end
          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :debian, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Debian
