require 'chef/provider/lwrp_base'
require_relative 'helpers_rhel'

class Chef
  class Provider
    class HttpdConfig
      class Rhel < Chef::Provider::HttpdConfig
        use_inline_resources if defined?(use_inline_resources)

        include Httpd::Helpers::Rhel

        def whyrun_supported?
          true
        end

        def action_create
          directory "#{new_resource.name} create /etc/#{apache_name}/conf.d" do
            path "/etc/#{apache_name}/conf.d"
            owner 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          template "#{new_resource.name} create /etc/#{apache_name}/conf.d/#{new_resource.config_name}.conf" do
            path "/etc/#{apache_name}/conf.d/#{new_resource.config_name}.conf"
            owner 'root'
            group 'root'
            mode '0644'
            variables(new_resource.variables)
            source new_resource.source
            cookbook new_resource.cookbook
            action :create
          end
        end

        def action_delete
          file "#{new_resource.name} create /etc/#{apache_name}/conf.d/#{new_resource.config_name}" do
            path "/etc/#{apache_name}/conf.d/#{new_resource.config_name}.conf"
            action :create
          end
        end
      end
    end
  end
end
