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
            directory "/etc/#{apache_name}/mods-available/" do
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            template "/etc/#{apache_name}/mods-available/#{module_name}.load" do
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

            directory "/etc/#{apache_name}/mods-enabled/" do
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            link "/etc/#{apache_name}/mods-enabled/#{module_name}.load" do
              target_file "/etc/#{apache_name}/mods-enabled/#{module_name}.load"
              to "/etc/#{apache_name}/mods-available/#{module_name}.load"
              action :create
            end

          end
        end

        action :delete do
          converge_by 'debian pattern' do
          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :debian, :resource => :httpd_module, :provider => Chef::Provider::HttpdModule::Debian
Chef::Platform.set :platform => :ubuntu, :resource => :httpd_module, :provider => Chef::Provider::HttpdModule::Debian
