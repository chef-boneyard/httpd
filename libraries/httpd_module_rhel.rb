module HttpdCookbook
  class HttpdModuleRhel < HttpdModule
    use_automatic_resource_name
    provides :httpd_module, platform_family: %w(rhel fedora suse amazon)

    action :create do
      package new_resource.package_name do
        action :install
      end

      # 2.2 vs 2.4
      if new_resource.httpd_version.to_f < 2.4
        directory "/etc/#{apache_name}/conf.d" do
          owner 'root'
          group 'root'
          recursive true
          action :create
        end

        template "/etc/#{apache_name}/conf.d/#{new_resource.module_name}.load" do
          source 'module_load.erb'
          owner 'root'
          group 'root'
          mode '0644'
          variables(
            module_name: new_resource.symbolname,
            module_path: module_path
          )
          cookbook 'httpd'
          action :create
        end
      elsif !built_in_module?(new_resource.module_name) # don't load built-ins on opensuse
        directory "/etc/#{apache_name}/conf.modules.d" do
          owner 'root'
          group 'root'
          recursive true
          action :create
        end

        template "/etc/#{apache_name}/conf.modules.d/#{new_resource.module_name}.load" do
          source 'module_load.erb'
          owner 'root'
          group 'root'
          mode '0644'
          variables(
            module_name: new_resource.symbolname,
            module_path: module_path
          )
          cookbook 'httpd'
          action :create
        end
      end
    end

    action :delete do
      if new_resource.httpd_version.to_f < 2.4
        file "/etc/#{apache_name}/conf.d/#{new_resource.module_name}.load" do
          action :delete
        end
      else
        file "/etc/#{apache_name}/conf.modules.d/#{new_resource.module_name}.load" do
          action :delete
        end
      end
    end

    include HttpdCookbook::Helpers::Rhel
  end
end
