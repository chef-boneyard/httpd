module HttpdCookbook
  class HttpdModuleDebian < HttpdModule
    use_automatic_resource_name

    provides :httpd_module, platform_family: 'debian'

    action :create do
      package package_name do
        action :install
      end

      directory "/etc/#{apache_name}/mods-available" do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      directory "/etc/#{apache_name}/mods-enabled" do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      template "/etc/#{apache_name}/mods-available/#{module_name}.load" do
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

      link "/etc/#{apache_name}/mods-enabled/#{module_name}.load" do
        to "/etc/#{apache_name}/mods-available/#{module_name}.load"
        action :create
      end
    end

    action :delete do
      directory "/etc/#{apache_name}/mods-available" do
        recursive true
        action :delete
      end

      file "/etc/#{apache_name}/mods-available/#{module_name}.load" do
        action :delete
      end

      link "/etc/#{apache_name}/mods-enabled/#{module_name}.load" do
        action :delete
      end
    end

    include HttpdCookbook::Helpers::Debian
  end
end
