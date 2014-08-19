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
          directory "#{new_resource.parsed_name} create /etc/#{apache_name}/conf.d" do
            path "/etc/#{apache_name}/conf.d"
            owner 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          template "#{new_resource.parsed_name} create /etc/#{apache_name}/conf.d/#{new_resource.parsed_config_name}.conf" do
            path "/etc/#{apache_name}/conf.d/#{new_resource.parsed_config_name}.conf"
            owner 'root'
            group 'root'
            mode '0644'
            variables(new_resource.parsed_variables)
            source new_resource.parsed_source
            cookbook new_resource.parsed_cookbook
            action :create
          end
        end

        def action_delete
          file "#{new_resource.parsed_name} create /etc/#{apache_name}/conf.d/#{new_resource.parsed_config_name}" do
            path "/etc/#{apache_name}/conf.d/#{new_resource.parsed_config_name}.conf"
            action :create
          end
        end
      end
    end
  end
end
