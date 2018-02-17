module HttpdCookbook
  class HttpdConfigDebian < HttpdConfig
    use_automatic_resource_name
    provides :httpd_config, platform_family: 'debian'

    action :create do
      if new_resource.httpd_version.to_f < 2.4
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
      else
        directory "/etc/#{apache_name}/conf-available" do
          owner 'root'
          group 'root'
          mode '0755'
          recursive true
          action :create
        end

        template "/etc/#{apache_name}/conf-available/#{new_resource.config_name}.conf" do
          owner 'root'
          group 'root'
          mode '0644'
          variables(new_resource.variables)
          source new_resource.source
          cookbook new_resource.cookbook
          sensitive new_resource.sensitive if new_resource.sensitive
          action :create
        end

        directory "/etc/#{apache_name}/conf-enabled" do
          owner 'root'
          group 'root'
          mode '0755'
          recursive true
          action :create
        end

        link "/etc/#{apache_name}/conf-enabled/#{new_resource.config_name}.conf" do
          to "/etc/#{apache_name}/conf-available/#{new_resource.config_name}.conf"
          action :create
        end
      end
    end

    action :delete do
      if new_resource.httpd_version.to_f < 2.4
        file "/etc/#{apache_name}/conf.d/#{new_resource.config_name}.conf" do
          action :delete
        end
      else
        file "/etc/#{apache_name}/conf-available/#{new_resource.config_name}.conf" do
          action :delete
        end

        link "/etc/#{apache_name}/conf-enabled/#{new_resource.config_name}.conf" do
          to "/etc/#{apache_name}/conf-available/#{new_resource.config_name}.conf"
          action :delete
        end
      end
    end

    include HttpdCookbook::Helpers::Debian
  end
end
