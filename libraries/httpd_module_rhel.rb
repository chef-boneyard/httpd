module HttpdCookbook
  class HttpdModuleRhel < HttpdModule
    use_automatic_resource_name
    provides :httpd_module, platform_family: %w(rhel fedora suse)

    action :create do
      # package_name is set by resource
      package package_name do
        action :install
      end

      # 2.2 vs 2.4
      if httpd_version.to_f < 2.4
        directory "/etc/#{apache_name}/conf.d" do
          owner 'root'
          group 'root'
          recursive true
          action :create
        end

        template "/etc/#{apache_name}/conf.d/#{module_name}.load" do
          source 'module_load.erb'
          owner 'root'
          group 'root'
          mode '0644'
          variables(
            module_name: symbolname,
            module_path: module_path
          )
          cookbook 'httpd'
          action :create
        end
      elsif !built_in_module?(module_name) # don't load built-ins on opensuse
        directory "/etc/#{apache_name}/conf.modules.d" do
          owner 'root'
          group 'root'
          recursive true
          action :create
        end

        template "/etc/#{apache_name}/conf.modules.d/#{module_name}.load" do
          source 'module_load.erb'
          owner 'root'
          group 'root'
          mode '0644'
          variables(
            module_name: symbolname,
            module_path: module_path
          )
          cookbook 'httpd'
          action :create
        end
      end
    end

    action :delete do
      if httpd_version.to_f < 2.4
        file "/etc/#{apache_name}/conf.d/#{module_name}.load" do
          action :delete
        end
      else
        file "/etc/#{apache_name}/conf.modules.d/#{module_name}.load" do
          action :delete
        end
      end
    end

    include HttpdCookbook::Helpers::Rhel
  end
end
