module HttpdCookbook
  class HttpdModuleDebian < HttpdModule
    use_automatic_resource_name

    provides :httpd_module, platform_family: 'debian'

    action :create do
      package "#{new_resource.name} :create #{parsed_module_package_name}" do
        package_name parsed_module_package_name
        action :install
      end

      directory "#{name} :create /etc/#{apache_name}/mods-available" do
        path "/etc/#{apache_name}/mods-available"
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      directory "#{name} :create /etc/#{apache_name}/mods-enabled" do
        path "/etc/#{apache_name}/mods-enabled"
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      template "#{name} :create /etc/#{apache_name}/mods-available/#{module_name}.load" do
        path "/etc/#{apache_name}/mods-available/#{module_name}.load"
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

      link "#{name} :create /etc/#{apache_name}/mods-enabled/#{module_name}.load" do
        target_file "/etc/#{apache_name}/mods-enabled/#{module_name}.load"
        to "/etc/#{apache_name}/mods-available/#{module_name}.load"
        action :create
      end
    end

    action :delete do
      directory "#{name} :delete /etc/#{apache_name}/mods-available" do
        path "/etc/#{apache_name}/mods-available"
        recursive true
        action :delete
      end

      file "#{name} :delete /etc/#{apache_name}/mods-available/#{module_name}.load" do
        path "/etc/#{apache_name}/mods-available/#{module_name}.load"
        action :delete
      end

      link "#{name} :delete /etc/#{apache_name}/mods-enabled/#{module_name}.load" do
        target_file "/etc/#{apache_name}/mods-enabled/#{module_name}.load"
        action :delete
      end
    end

    include HttpdCookbook::Helpers::Debian
  end
end
