module HttpdCookbook
  class HttpdConfigDebian < HttpdConfig
    use_automatic_resource_name
    provides :httpd_config, platform_family: 'debian'

    action :create do
      if httpd_version.to_f < 2.4
        directory "/etc/#{apache_name}/conf.d" do
          owner 'root'
          group 'root'
          mode '0755'
          recursive true
          action :create
        end

        template "/etc/#{apache_name}/conf.d/#{config_name}.conf" do
          owner 'root'
          group 'root'
          mode '0644'
          variables(new_resource.variables)
          source new_resource.source
          cookbook new_resource.cookbook
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

        template "/etc/#{apache_name}/conf-available/#{config_name}.conf" do
          owner 'root'
          group 'root'
          mode '0644'
          variables(new_resource.variables)
          source new_resource.source
          cookbook new_resource.cookbook
          action :create
        end

        directory "/etc/#{apache_name}/conf-enabled" do
          owner 'root'
          group 'root'
          mode '0755'
          recursive true
          action :create
        end

        link "/etc/#{apache_name}/conf-enabled/#{config_name}.conf" do
          to "/etc/#{apache_name}/conf-available/#{config_name}.conf"
          action :create
        end
      end
    end

    action :delete do
      if httpd_version.to_f < 2.4
        file "/etc/#{apache_name}/conf.d/#{config_name}.conf" do
          action :delete
        end
      else
        file "/etc/#{apache_name}/conf-available/#{config_name}.conf" do
          action :delete
        end

        link "/etc/#{apache_name}/conf-enabled/#{config_name}.conf" do
          to "/etc/#{apache_name}/conf-available/#{config_name}.conf"
          action :delete
        end
      end
    end

    include HttpdCookbook::Helpers::Debian
  end
end
