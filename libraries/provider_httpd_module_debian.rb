require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdModule
      class Debian < Chef::Provider::HttpdModule
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'debian pattern' do
            #
            # local variables
            #
            module_name = new_resource.name
            module_path = "/usr/lib/apache2/modules/mod_#{module_name}.so"
            new_resource.httpd_instance == 'default' ? apache_name = 'apache2' : apache_name = "apache2-#{new_resource.httpd_instance}"

            #
            # resources
            #
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

            directory "#{new_resource.name} create /etc/#{apache_name}/mods-available/" do
              path "/etc/#{apache_name}/mods-available/"
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            template "#{new_resource.name} create /etc/#{apache_name}/mods-available/#{module_name}.load" do
              path "/etc/#{apache_name}/mods-available/#{module_name}.load"
              source 'module_load.erb'
              owner 'root'
              mode '0644'
              variables(
                :module_name => "#{module_name}_module",
                :module_path => module_path
                )
              cookbook 'httpd'
              action :create
            end

            directory "#{new_resource.name} create /etc/#{apache_name}/mods-enabled/" do
              path "/etc/#{apache_name}/mods-enabled/"
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            link "#{new_resource.name} create /etc/#{apache_name}/mods-enabled/#{module_name}.load" do
              target_file "/etc/#{apache_name}/mods-enabled/#{module_name}.load"
              to "/etc/#{apache_name}/mods-available/#{module_name}.load"
              action :create
            end
          end
        end

        action :delete do
          converge_by 'debian pattern' do
            #
            # local variables
            #
            module_name = new_resource.name
            new_resource.httpd_instance == 'default' ? apache_name = 'apache2' : apache_name = "apache2-#{new_resource.httpd_instance}"

            #
            # resources
            #
            directory "#{new_resource.name} delete /etc/#{apache_name}/mods-available/" do
              path "/etc/#{apache_name}/mods-available/"
              recursive true
              action :delete
            end

            file "#{new_resource.name} delete /etc/#{apache_name}/mods-available/#{module_name}.load" do
              path "/etc/#{apache_name}/mods-available/#{module_name}.load"
              action :delete
            end

            directory "#{new_resource.name} delete /etc/#{apache_name}/mods-enabled/" do
              path "/etc/#{apache_name}/mods-enabled/"
              recursive true
              action :delete
            end

            link "#{new_resource.name} delete /etc/#{apache_name}/mods-enabled/#{module_name}.load" do
              target_file "/etc/#{apache_name}/mods-enabled/#{module_name}.load"
              action :delete
            end
          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :debian, :resource => :httpd_module, :provider => Chef::Provider::HttpdModule::Debian
Chef::Platform.set :platform => :ubuntu, :resource => :httpd_module, :provider => Chef::Provider::HttpdModule::Debian
