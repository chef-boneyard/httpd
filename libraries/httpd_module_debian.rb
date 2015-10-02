module HttpdCookbook
  class HttpdModuleDebian < HttpdModule
    use_automatic_resource_name

    provides :httpd_module, platform_family: 'debian'

    action :create do
      package "#{new_resource.name} :create #{parsed_module_package_name}" do
        package_name parsed_module_package_name
        action :install
      end

      directory "#{new_resource.name} :create /etc/#{apache_name}/mods-available" do
        path "/etc/#{apache_name}/mods-available"
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      directory "#{new_resource.name} :create /etc/#{apache_name}/mods-enabled" do
        path "/etc/#{apache_name}/mods-enabled"
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      template "#{new_resource.name} :create /etc/#{apache_name}/mods-available/#{module_name}.load" do
        path "/etc/#{apache_name}/mods-available/#{module_name}.load"
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

      link "#{new_resource.name} :create /etc/#{apache_name}/mods-enabled/#{module_name}.load" do
        target_file "/etc/#{apache_name}/mods-enabled/#{module_name}.load"
        to "/etc/#{apache_name}/mods-available/#{module_name}.load"
        action :create
      end
    end

    action :delete do
      directory "#{new_resource.name} :delete /etc/#{apache_name}/mods-available" do
        path "/etc/#{apache_name}/mods-available"
        recursive true
        action :delete
      end

      file "#{new_resource.name} :delete /etc/#{apache_name}/mods-available/#{module_name}.load" do
        path "/etc/#{apache_name}/mods-available/#{module_name}.load"
        action :delete
      end

      link "#{new_resource.name} :delete /etc/#{apache_name}/mods-enabled/#{module_name}.load" do
        target_file "/etc/#{apache_name}/mods-enabled/#{module_name}.load"
        action :delete
      end
    end

    action_class.class_eval { include HttpdCookbook::Helpers::Debian }
  end
end
