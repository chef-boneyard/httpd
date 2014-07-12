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
          module_name = new_resource.name
          module_path = "/usr/#{libarch}/httpd/modules/mod_#{module_name}.so"

          # support multiple instances
          new_resource.httpd_instance == 'default' ? apache_name = 'httpd' : apache_name = "httpd-#{new_resource.name}"

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
            command "rm -f /etc/#{apache_name}/conf.d/*"
            only_if "test -f /etc/#{apache_name}/conf.d/README"
            action :nothing
          end

          directory "#{new_resource.name} create /usr/#{libarch}/httpd/modules" do
            path "/usr/#{libarch}/httpd/modules"
            user 'root'
            group 'root'
            mode '0755'
            recursive true
            action :create
          end

          link "#{new_resource.name} create /etc/#{apache_name}/modules" do
            target_file "/etc/#{apache_name}/modules"
            to "../../usr/#{libarch}/modules"
            action :create
          end

          directory "#{new_resource.name} create /etc/#{apache_name}/conf.modules.d" do
            path "/etc/#{apache_name}/conf.modules.d"
            owner 'root'
            group 'root'
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

        action :delete do
        end
      end
    end
  end
end

Chef::Platform.set :platform => :amazon, :resource => :httpd_module, :provider => Chef::Provider::HttpdModule::Rhel
Chef::Platform.set :platform => :redhat, :resource => :httpd_module, :provider => Chef::Provider::HttpdModule::Rhel
Chef::Platform.set :platform => :centos, :resource => :httpd_module, :provider => Chef::Provider::HttpdModule::Rhel
Chef::Platform.set :platform => :oracle, :resource => :httpd_module, :provider => Chef::Provider::HttpdModule::Rhel
Chef::Platform.set :platform => :scientific, :resource => :httpd_module, :provider => Chef::Provider::HttpdModule::Rhel
