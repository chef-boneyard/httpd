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

            # calculate debian major version from node attributes
            debian_major_version = "debian-#{node['platform_version'].to_i}"

            # We need to dynamically render the resource name into the title in
            # order to ensure uniqueness. This avoids cloning via
            # CHEF-3694 and allows ChefSpec and Chef 10 to work properly

            # software installation
            package "#{new_resource.name} create #{new_resource.package_name}" do
              package_name new_resource.package_name
              notifies :run, "bash[#{new_resource.name} create remove_package_config]", :immediately
              action :install
            end

            bash "#{new_resource.name} create remove_package_config" do
              user 'root'
              code <<-EOH
              for i in `ls /etc/apache2 | egrep -v "envvars|apache2.conf"` ; do rm -rf /etc/apache2/$i ; done
              EOH
              action :nothing
            end

            # support directories
            directory "#{new_resource.name} create /var/cache/#{apache_name}" do
              path "/var/cache/#{apache_name}"
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "#{new_resource.name} create /var/log/#{apache_name}" do
              path "/var/log/#{apache_name}"
              owner 'root'
              group 'adm'
              mode '0755'
              action :create
            end

            directory "#{new_resource.name} create /var/run/#{apache_name}" do
              path "/var/run/#{apache_name}"
              owner 'root'
              group 'adm'
              mode '0755'
              action :create
            end

            # configuration directories
            directory "#{new_resource.name} create /etc/#{apache_name}" do
              path "/etc/#{apache_name}"
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            # configuration directories
            if apache_version.to_f < 2.4
              directory "#{new_resource.name} create /etc/#{apache_name}/conf.d" do
                path "/etc/#{apache_name}/conf.d"
                owner 'root'
                group 'root'
                mode '0755'
                action :create
              end
            else
              directory "#{new_resource.name} create /etc/#{apache_name}/conf-available" do
                path "/etc/#{apache_name}/conf-available"
                owner 'root'
                group 'root'
                mode '0755'
                action :create
              end

              directory "#{new_resource.name} create /etc/#{apache_name}/conf-enabled" do
                path "/etc/#{apache_name}/conf-enabled"
                owner 'root'
                group 'root'
                mode '0755'
                action :create
              end
            end

            directory "#{new_resource.name} create /etc/#{apache_name}/mods-available" do
              path "/etc/#{apache_name}/mods-available"
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "#{new_resource.name} create /etc/#{apache_name}/mods-enabled" do
              path "/etc/#{apache_name}/mods-enabled"
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "#{new_resource.name} create /etc/#{apache_name}/sites-available" do
              path "/etc/#{apache_name}/sites-available"
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            directory "#{new_resource.name} create /etc/#{apache_name}/sites-enabled" do
              path "/etc/#{apache_name}/sites-enabled"
              owner 'root'
              group 'root'
              mode '0755'
              action :create
            end

            # envvars
            template "#{new_resource.name} create /etc/#{apache_name}/envvars" do
              path "/etc/#{apache_name}/envvars"
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
            template "#{new_resource.name} create /usr/sbin/a2enmod" do
              path '/usr/sbin/a2enmod'
              source "#{apache_version}/scripts/a2enmod.erb"
              owner 'root'
              group 'root'
              mode '0755'
              cookbook 'httpd'
              action :create
            end

            link "#{new_resource.name} create /usr/sbin/#{a2enmod_name}" do
              target_file "/usr/sbin/#{a2enmod_name}"
              to '/usr/sbin/a2enmod'
              owner 'root'
              group 'root'
              not_if "test -f /usr/sbin/#{a2enmod_name}"
              action :create
            end

            link "#{new_resource.name} create /usr/sbin/#{a2dismod_name}" do
              target_file "/usr/sbin/#{a2dismod_name}"
              to '/usr/sbin/a2enmod'
              owner 'root'
              group 'root'
              action :create
            end

            link "#{new_resource.name} create /usr/sbin/#{a2ensite_name}" do
              target_file "/usr/sbin/#{a2ensite_name}"
              to '/usr/sbin/a2enmod'
              owner 'root'
              group 'root'
              action :create
            end

            link "#{new_resource.name} create /usr/sbin/#{a2dissite_name}" do
              target_file "/usr/sbin/#{a2dissite_name}"
              to '/usr/sbin/a2enmod'
              owner 'root'
              group 'root'
              action :create
            end

            # configuration files
            template "#{new_resource.name} create /etc/#{apache_name}/magic" do
              path "/etc/#{apache_name}/magic"
              source "#{apache_version}/magic.erb"
              owner 'root'
              group 'root'
              mode '0644'
              cookbook 'httpd'
              action :create
            end

            file "#{new_resource.name} create /etc/#{apache_name}/ports.conf" do
              path "/etc/#{apache_name}/ports.conf"
              action :delete
            end

            template "#{new_resource.name} create /etc/#{apache_name}/apache2.conf" do
              path "/etc/#{apache_name}/apache2.conf"
              source "#{apache_version}/apache2.conf.erb"
              owner 'root'
              group 'root'
              mode '0644'
              variables(
                :config => new_resource,
                :apache_name => apache_name
                )
              cookbook 'httpd'
              notifies :restart, "service[#{new_resource.name} create #{apache_name}]"
              action :create
            end

            # init script
            template "#{new_resource.name} create /etc/init.d/#{apache_name}" do
              path "/etc/init.d/#{apache_name}"
              source "#{apache_version}/sysvinit/#{debian_major_version}/apache2.erb"
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
              action [:start, :enable]
              supports :restart => true, :reload => true, :status => true
              provider Chef::Provider::Service::Init::Debian
            end
          end
        end

        action :delete do
          # local variables
          apache_version = new_resource.version

          # support multiple instances
          new_resource.name == 'default' ? apache_name = 'apache2' : apache_name = "apache2-#{new_resource.name}"
          new_resource.name == 'default' ? a2enmod_name = 'a2enmod' : a2enmod_name = "a2enmod-#{new_resource.name}"
          new_resource.name == 'default' ? a2dismod_name = 'a2dismod' : a2dismod_name = "a2dismod-#{new_resource.name}"
          new_resource.name == 'default' ? a2ensite_name = 'a2ensite' : a2ensite_name = "a2ensite-#{new_resource.name}"
          new_resource.name == 'default' ? a2dissite_name = 'a2dissite' : a2dissite_name = "a2dissite-#{new_resource.name}"

          # We need to dynamically render the resource name into the title in
          # order to ensure uniqueness. In addition to this, we need
          # to render the extra string 'delete' to isolate it from action
          # :create This avoids cloning via CHEF-3694 and allows
          # ChefSpec and Chef 10 to work properly

          # Software installation: This is needed to supply the init
          # script that powers the service facility.
          package "#{new_resource.name} delete #{new_resource.package_name}" do
            package_name new_resource.package_name
            notifies :run, "bash[#{new_resource.name} delete remove_package_config]", :immediately
            action :install
          end

          bash "#{new_resource.name} delete remove_package_config" do
            user 'root'
            code <<-EOH
              for i in `ls /etc/apache2 | egrep -v "envvars|apache2.conf"` ; do rm -rf /etc/apache2/$i ; done
              EOH
            action :nothing
          end

          # service management
          service "#{new_resource.name} delete #{apache_name}" do
            service_name apache_name
            pattern 'apache2'
            action [:disable, :stop]
            provider Chef::Provider::Service::Init::Debian
          end

          # support directories
          directory "#{new_resource.name} delete /var/cache/#{apache_name}" do
            path "/var/cache/#{apache_name}"
            recursive true
            action :delete
          end

          directory "#{new_resource.name} delete /var/log/#{apache_name}" do
            path "/var/log/#{apache_name}"
            recursive true
            action :delete
          end

          directory "#{new_resource.name} delete /var/run/#{apache_name}" do
            path "/var/run/#{apache_name}"
            recursive true
            action :delete
          end

          # configuation directories
          if apache_version.to_f < 2.4
            directory "#{new_resource.name} delete /etc/#{apache_name}/conf.d" do
              path "/etc/#{apache_name}/conf.d"
              recursive true
              action :delete
            end
          else
            directory "#{new_resource.name} delete /etc/#{apache_name}/conf-available" do
              path "/etc/#{apache_name}/conf-available"
              owner 'root'
              group 'root'
              mode '0755'
              action :delete
            end

            directory "#{new_resource.name} delete /etc/#{apache_name}/conf-enabled" do
              path "/etc/#{apache_name}/conf-enabled"
              recursive true
              action :delete
            end
          end

          directory "#{new_resource.name} delete /etc/#{apache_name}/mods-available" do
            path "/etc/#{apache_name}/mods-available"
            recursive true
            action :delete
          end

          directory "#{new_resource.name} delete /etc/#{apache_name}/mods-enabled" do
            path "/etc/#{apache_name}/mods-enabled"
            recursive true
            action :delete
          end

          directory "#{new_resource.name} delete /etc/#{apache_name}/sites-available" do
            path "/etc/#{apache_name}/sites-available"
            recursive true
            action :delete
          end

          directory "#{new_resource.name} delete /etc/#{apache_name}/sites-enabled" do
            path "/etc/#{apache_name}/sites-enabled"
            recursive true
            action :delete
          end

          # utility scripts
          file "#{new_resource.name} delete /usr/sbin/#{a2enmod_name}" do
            path "/usr/sbin/#{a2enmod_name}"
            action :delete
          end

          link "#{new_resource.name} delete /usr/sbin/#{a2dismod_name}" do
            target_file "/usr/sbin/#{a2dismod_name}"
            action :delete
          end

          link "#{new_resource.name} delete /usr/sbin/#{a2ensite_name}" do
            target_file "/usr/sbin/#{a2ensite_name}"
            action :delete
          end

          link "#{new_resource.name} delete /usr/sbin/#{a2dissite_name}" do
            target_file "/usr/sbin/#{a2dissite_name}"
            action :delete
          end

          file "#{new_resource.name} delete /etc/#{apache_name}/magic" do
            path "/etc/#{apache_name}/magic"
            action :delete
          end

          file "#{new_resource.name} delete /etc/#{apache_name}/ports.conf" do
            path "/etc/#{apache_name}/ports.conf"
            action :delete
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
