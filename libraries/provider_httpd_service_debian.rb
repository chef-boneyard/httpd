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
            if new_resource.name == 'default'
              apache_name = 'apache2'
            else
              apache_name = "apache2-#{new_resource.name}"
            end

            # software installation
            package new_resource.package_name do
              action :install
            end

            # support directories
            directory "/var/cache/#{apache_name}" do
              owner 'root'
              group 'root'
              action :create
            end

            directory "/var/log/#{apache_name}" do
              owner 'root'
              group 'adm'
              action :create
            end

            directory "/var/run/#{apache_name}" do
              owner 'root'
              group 'adm'
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

            directory "/etc/#{apache_name}/mods-enabled" do
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "/etc/#{apache_name}/mods-available" do
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

            directory "/etc/#{apache_name}/conf-available" do
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

            directory "/etc/#{apache_name}/sites-available" do
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

            link '/usr/sbin/a2dismod' do
              to '/usr/sbin/a2enmod'
              owner 'root'
              group 'root'
              action :create
            end

            link '/usr/sbin/a2dissite' do
              to '/usr/sbin/a2enmod'
              owner 'root'
              group 'root'
              action :create
            end

            link '/usr/sbin/a2ensite' do
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

            # configuration file
            template "/etc/#{apache_name}/apache2.conf" do
              source "#{apache_version}/apache2.conf.erb"
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
          converge_by 'debian pattern' do
            service apache_name do
              provider Chef::Provider::Service::Init::Debian
              supports :restart => true
              action :restart
            end
          end
        end

        action :reload do
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
