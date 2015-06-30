require 'chef/provider/lwrp_base'
require_relative 'helpers'
require_relative 'helpers_rhel'

class Chef
  class Provider
    class HttpdModuleRhel < Chef::Provider::LWRPBase
      include HttpdCookbook::Helpers
      include HttpdCookbook::Helpers::Rhel

      provides :httpd_module, platform_family: %w(rhel fedora suse)

      use_inline_resources

      def whyrun_supported?
        true
      end

      action :create do
        # package_name is set by resource
        package "#{new_resource.name} :create #{parsed_module_package_name}" do
          package_name parsed_module_package_name
          action :install
        end

        # 2.2 vs 2.4
        if parsed_httpd_version.to_f < 2.4
          directory "#{new_resource.name} :create /etc/#{apache_name}/conf.d" do
            path "/etc/#{apache_name}/conf.d"
            owner 'root'
            group 'root'
            recursive true
            action :create
          end

          template "#{new_resource.name} :create /etc/#{apache_name}/conf.d/#{module_name}.load" do
            path "/etc/#{apache_name}/conf.d/#{module_name}.load"
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
        else
          directory "#{new_resource.name} :create /etc/#{apache_name}/conf.modules.d" do
            path "/etc/#{apache_name}/conf.modules.d"
            owner 'root'
            group 'root'
            recursive true
            action :create
          end

          template "#{new_resource.name} :create /etc/#{apache_name}/conf.modules.d/#{module_name}.load" do
            path "/etc/#{apache_name}/conf.modules.d/#{module_name}.load"
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
        end
      end

      action :delete do
        if parsed_httpd_version.to_f < 2.4
          file "#{new_resource.name} :delete /etc/#{apache_name}/conf.d/#{module_name}.load" do
            path "/etc/#{apache_name}/conf.d/#{module_name}.load"
            action :delete
          end
        else
          file "#{new_resource.name} :delete /etc/#{apache_name}/conf.modules.d/#{module_name}.load" do
            path "/etc/#{apache_name}/conf.modules.d/#{module_name}.load"
            action :delete
          end
        end
      end
    end
  end
end
