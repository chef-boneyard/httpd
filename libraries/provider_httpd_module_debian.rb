require 'chef/provider/lwrp_base'
require_relative 'helpers_debian'

class Chef
  class Provider
    class HttpdModule
      class Debian < Chef::Provider::HttpdModule
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        include HttpdCookbook::Helpers
        include HttpdCookbook::Helpers::Debian

        action :create do
          package "#{new_resource.name} :create #{parsed_module_package_name}" do
            package_name parsed_module_package_name
            action :install
          end

          directory "#{new_resource.name} :create /etc/#{apache_name}/mods-available" do
            path "/etc/#{apache_name}/mods-available"
            owner 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          directory "#{new_resource.name} :create /etc/#{apache_name}/mods-enabled" do
            path "/etc/#{apache_name}/mods-enabled"
            owner 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          template "#{new_resource.name} :create /etc/#{apache_name}/mods-available/#{module_name}.load" do
            path "/etc/#{apache_name}/mods-available/#{module_name}.load"
            source 'module_load.erb'
            owner 'root'
            group 'root'
            mode '0644'
            variables(
              module_name: parsed_symbolname,
              module_path: module_path
              )
            cookbook 'httpd'
            action :create
          end

          link "#{new_resource.name} :create /etc/#{apache_name}/mods-enabled/#{module_name}.load" do
            target_file "/etc/#{apache_name}/mods-enabled/#{module_name}.load"
            to "/etc/#{apache_name}/mods-available/#{module_name}.load"
            action :create
          end
        end
      end

      action :delete do
        directory "#{new_resource.name} :delete /etc/#{apache_name}/mods-available" do
          path "/etc/#{apache_name}/mods-available"
          recursive true
          action :delete
        end

        file "#{new_resource.name} :delete /etc/#{apache_name}/mods-available/#{module_name}.load" do
          path "/etc/#{apache_name}/mods-available/#{module_name}.load"
          action :delete
        end

        link "#{new_resource.name} :delete /etc/#{apache_name}/mods-enabled/#{module_name}.load" do
          target_file "/etc/#{apache_name}/mods-enabled/#{module_name}.load"
          action :delete
        end
      end
    end
  end
end
