require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdConfig
      class Rhel < Chef::Provider::HttpdConfig
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          # support multiple instances
          new_resource.instance == 'default' ? apache_name = 'httpd' : apache_name = new_resource.instance

          #
          # resources
          #
          directory "#{new_resource.name} create /etc/#{apache_name}/conf.d" do
            path "/etc/#{apache_name}/conf.d/"
            owner 'root'
            group 'root'
            recursive true
            action :create
          end

          template "#{new_resource.name} create #{new_resource.config_name}" do
            path "/etc/#{apache_name}/conf.d/#{new_resource.config_name}.conf"
            source new_resource.source
            cookbook new_resource.cookbook
            action :create
          end
        end

        action :delete do
          file "#{new_resource.name} create #{new_resource.config_name}" do
            path "/etc/#{apache_name}/conf.d/#{new_resource.config_name}.conf"
            action :create
          end
        end
      end
    end
  end
end
