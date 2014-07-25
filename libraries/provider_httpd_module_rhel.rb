require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdModule
      class Rhel < Chef::Provider::HttpdModule
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

          # paths
          module_name = new_resource.module_name
          module_path = "/usr/#{libarch}/httpd/modules/mod_#{module_name}.so"

          # support multiple instances
          new_resource.instance == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.instance}"

          #
          # resources
          #
          package "#{new_resource.name} create #{new_resource.package_name}" do
            package_name new_resource.package_name
            notifies :run, "execute[#{new_resource.name} create remove_package_config]", :immediately
            action :install
          end

          execute "#{new_resource.name} create remove_package_config" do
            user 'root'
            command "rm -rf /etc/#{apache_name}"
            only_if { new_resource.package_name == 'httpd' }
            action :nothing
          end

          if new_resource.httpd_version.to_f < 2.4
            directory "#{new_resource.name} create /etc/#{apache_name}/conf.d" do
              path "/etc/#{apache_name}/conf.d"
              owner 'root'
              group 'root'
              recursive true
              action :create
            end

            template "#{new_resource.name} create /etc/#{apache_name}/conf.d/#{module_name}.load" do
              path "/etc/#{apache_name}/conf.d/#{module_name}.load"
              source 'module_load.erb'
              owner 'root'
              group 'root'
              mode '0644'
              variables(
                :module_name => "#{module_name}_module",
                :module_path => module_path
                )
              cookbook 'httpd'
              action :create
            end
          else
            directory "#{new_resource.name} create /etc/#{apache_name}/conf.modules.d" do
              path "/etc/#{apache_name}/conf.modules.d"
              owner 'root'
              group 'root'
              recursive true
              action :create
            end

            template "#{new_resource.name} create /etc/#{apache_name}/conf.modules.d/#{module_name}.load" do
              path "/etc/#{apache_name}/conf.modules.d/#{module_name}.load"
              source 'module_load.erb'
              owner 'root'
              group 'root'
              mode '0644'
              variables(
                :module_name => "#{module_name}_module",
                :module_path => module_path
                )
              cookbook 'httpd'
              action :create
            end
          end
        end

        action :delete do
          # support multiple instances
          new_resource.instance == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.instance}"

          if new_resource.httpd_version.to_f < 2.4
            file "#{new_resource.name} delete /etc/#{apache_name}/conf.d/#{module_name}.load" do
              path "/etc/#{apache_name}/conf.d/#{module_name}.load"
              action :delete
            end
          else
            file "#{new_resource.name} delete /etc/#{apache_name}/conf.modules.d/#{module_name}.load" do
              path "/etc/#{apache_name}/conf.modules.d/#{module_name}.load"
              action :delete
            end
          end
        end
      end
    end
  end
end
