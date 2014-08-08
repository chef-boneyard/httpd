require 'chef/provider/lwrp_base'
require_relative 'helpers_rhel'
require_relative 'module_details_dsl'

class Chef
  class Provider
    class HttpdModule
      class Rhel < Chef::Provider::HttpdModule
        use_inline_resources if defined?(use_inline_resources)

        include Httpd::Helpers::Rhel

        def whyrun_supported?
          true
        end

        def action_create
          extend Httpd::Module::Helpers

          # package_name is set by resource
          package "#{new_resource.name} create #{new_resource.package_name}" do
            package_name new_resource.package_name
            action :install
          end

          # remove cruft dropped off by package
          if new_resource.package_name == 'httpd'
            if new_resource.httpd_version.to_f < 2.4
              %w(
                /etc/httpd/conf.d/README
                /etc/httpd/conf.d/welcome.conf
              ).each do |f|
                file "#{new_resource.name} create #{f}" do
                  path f
                  action :nothing
                  subscribes :delete, "package[#{new_resource.name} create httpd]", :immediately
                end
              end
            else
              %w(
                /etc/httpd/conf.d/autoindex.conf
                /etc/httpd/conf.d/README
                /etc/httpd/conf.d/userdir.conf
                /etc/httpd/conf.d/welcome.conf
                /etc/httpd/conf.modules.d/00-base.conf
                /etc/httpd/conf.modules.d/00-dav.conf
                /etc/httpd/conf.modules.d/00-lua.conf
                /etc/httpd/conf.modules.d/00-mpm.conf
                /etc/httpd/conf.modules.d/00-proxy.conf
                /etc/httpd/conf.modules.d/00-systemd.conf
                /etc/httpd/conf.modules.d/01-cgi.conf
              ).each do |f|
                file "#{new_resource.name} create #{f}" do
                  path f
                  action :nothing
                  subscribes :delete, "package[#{new_resource.name} create httpd]", :immediately
                end
              end
            end
          end

          # voodoo people
          delete_files_for_module(
            new_resource.name,
            new_resource.httpd_version,
            node['platform'],
            node['platform_family'],
            node['platform_version']
            ).each do |f|
            file "#{new_resource.name} create #{f}" do
              path f
              action :nothing
              subscribes :delete, "package[#{new_resource.name} create #{new_resource.package_name}]", :immediately
            end
          end

          # 2.2 vs 2.4
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

        def action_delete
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
