module HttpdCookbook
  class HttpdConfigRhel < HttpdConfig
    use_automatic_resource_name
    provides :httpd_config, platform_family: %w(rhel fedora suse amazon)

    action :create do
      directory "/etc/#{apache_name}/conf.d" do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      template "/etc/#{apache_name}/conf.d/#{new_resource.config_name}.conf" do
        owner 'root'
        group 'root'
        mode '0644'
        variables(new_resource.variables)
        source new_resource.source
        cookbook new_resource.cookbook
        sensitive new_resource.sensitive if new_resource.sensitive
        action :create
      end
    end

    action :delete do
      file "/etc/#{apache_name}/conf.d/#{new_resource.config_name}.conf" do
        action :delete
      end
    end

    include HttpdCookbook::Helpers::Rhel
  end
end
