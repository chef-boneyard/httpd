require 'chef/provider/lwrp_base'
require_relative 'helpers_debian'

class Chef
  class Provider
    class HttpdConfig
      class Debian < Chef::Provider::HttpdConfig
        use_inline_resources if defined?(use_inline_resources)

        include Httpd::Helpers::Debian

        def whyrun_supported?
          true
        end

        action :create do
          if new_resource.parsed_httpd_version.to_f < 2.4
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
          else
            directory "#{new_resource.parsed_name} create /etc/#{apache_name}/conf-available" do
              path "/etc/#{apache_name}/conf-available"
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            template "#{new_resource.parsed_name} create /etc/#{apache_name}/conf-available/#{new_resource.parsed_config_name}.conf" do
              path "/etc/#{apache_name}/conf-available/#{new_resource.parsed_config_name}.conf"
              owner 'root'
              group 'root'
              mode '0644'
              variables(new_resource.parsed_variables)
              source new_resource.parsed_source
              cookbook new_resource.parsed_cookbook
              action :create
            end

            directory "#{new_resource.parsed_name} create /etc/#{apache_name}/conf-enabled" do
              path "/etc/#{apache_name}/conf-enabled"
              owner 'root'
              group 'root'
              mode '0755'
              recursive true
              action :create
            end

            link "#{new_resource.parsed_name} create /etc/#{apache_name}/conf-enabled/#{new_resource.parsed_config_name}.conf" do
              target_file "/etc/#{apache_name}/conf-enabled/#{new_resource.parsed_config_name}.conf"
              to "/etc/#{apache_name}/conf-available/#{new_resource.parsed_config_name}.conf"
              action :create
            end
          end
        end

        action :delete do
          if new_resource.parsed_httpd_version.to_f < 2.4
            file "#{new_resource.parsed_name} create /etc/#{apache_name}/conf.d/#{new_resource.parsed_config_name}.conf" do
              path "/etc/#{apache_name}/conf.d/#{new_resource.parsed_config_name}.conf"
              action :delete
            end
          else
            file "#{new_resource.parsed_name} create /etc/#{apache_name}/conf-available/#{new_resource.parsed_config_name}.conf" do
              path "/etc/#{apache_name}/conf-available/#{new_resource.parsed_config_name}.conf"
              action :delete
            end

            link "#{new_resource.parsed_name} create /etc/#{apache_name}/conf-enabled/#{new_resource.parsed_config_name}.conf" do
              target_file "/etc/#{apache_name}/conf-enabled/#{new_resource.parsed_config_name}.conf"
              to "/etc/#{apache_name}/conf-available/#{new_resource.parsed_config_name}.conf"
              action :delete
            end
          end
        end
      end
    end
  end
end
