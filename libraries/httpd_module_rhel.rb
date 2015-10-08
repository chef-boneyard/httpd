module HttpdCookbook
  class HttpdModuleRhel < HttpdModule
    use_automatic_resource_name
    provides :httpd_module, platform_family: %w(rhel fedora suse)

    action :create do
      # package_name is set by resource
      package "#{name} :create #{package_name}" do
        package_name new_resource.package_name
        action :install
      end

      # 2.2 vs 2.4
      if httpd_version.to_f < 2.4
        directory "#{name} :create /etc/#{apache_name}/conf.d" do
          path "/etc/#{apache_name}/conf.d"
          owner 'root'
          group 'root'
          recursive true
          action :create
        end

        template "#{name} :create /etc/#{apache_name}/conf.d/#{module_name}.load" do
          path "/etc/#{apache_name}/conf.d/#{module_name}.load"
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
      else
        directory "#{name} :create /etc/#{apache_name}/conf.modules.d" do
          path "/etc/#{apache_name}/conf.modules.d"
          owner 'root'
          group 'root'
          recursive true
          action :create
        end

        template "#{name} :create /etc/#{apache_name}/conf.modules.d/#{module_name}.load" do
          path "/etc/#{apache_name}/conf.modules.d/#{module_name}.load"
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
        file "#{name} :delete /etc/#{apache_name}/conf.d/#{module_name}.load" do
          path "/etc/#{apache_name}/conf.d/#{module_name}.load"
          action :delete
        end
      else
        file "#{name} :delete /etc/#{apache_name}/conf.modules.d/#{module_name}.load" do
          path "/etc/#{apache_name}/conf.modules.d/#{module_name}.load"
          action :delete
        end
      end
    end

    include HttpdCookbook::Helpers::Rhel
  end
end
