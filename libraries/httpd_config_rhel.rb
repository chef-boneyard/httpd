module HttpdCookbook
  class HttpdConfigRhel < HttpdConfig
    use_automatic_resource_name
    provides :httpd_config, platform_family: %w(rhel fedora suse)

    action :create do
      directory "#{name} :create /etc/#{apache_name}/conf.d" do
        path "/etc/#{apache_name}/conf.d"
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end

      template "#{name} :create /etc/#{apache_name}/conf.d/#{config_name}.conf" do
        path "/etc/#{apache_name}/conf.d/#{new_resource.config_name}.conf"
        owner 'root'
        group 'root'
        mode '0644'
        variables(new_resource.variables)
        source new_resource.source
        cookbook new_resource.cookbook
        action :create
      end
    end

    action :delete do
      file "#{name} :create /etc/#{apache_name}/conf.d/#{config_name}" do
        path "/etc/#{apache_name}/conf.d/#{new_resource.config_name}.conf"
        action :delete
      end
    end

    include HttpdCookbook::Helpers::Rhel
  end
end
