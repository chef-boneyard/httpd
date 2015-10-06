module HttpdCookbook
  class HttpdConfigDebian < HttpdConfig
    use_automatic_resource_name
    provides :httpd_config, platform_family: 'debian'

    action :create do
      if parsed_httpd_version.to_f < 2.4
        directory "#{name} :create /etc/#{apache_name}/conf.d" do
          path "/etc/#{apache_name}/conf.d"
          owner 'root'
          group 'root'
          mode '0755'
          recursive true
          action :create
        end

        template "#{name} :create /etc/#{apache_name}/conf.d/#{config_name}.conf" do
          path "/etc/#{apache_name}/conf.d/#{config_name}.conf"
          owner 'root'
          group 'root'
          mode '0644'
          variables(new_resource.variables)
          source new_resource.source
          cookbook new_resource.cookbook
          action :create
        end
      else
        directory "#{name} :create /etc/#{apache_name}/conf-available" do
          path "/etc/#{apache_name}/conf-available"
          owner 'root'
          group 'root'
          mode '0755'
          recursive true
          action :create
        end

        template "#{name} :create /etc/#{apache_name}/conf-available/#{config_name}.conf" do
          path "/etc/#{apache_name}/conf-available/#{config_name}.conf"
          owner 'root'
          group 'root'
          mode '0644'
          variables(new_resource.variables)
          source new_resource.source
          cookbook new_resource.cookbook
          action :create
        end

        directory "#{name} :create /etc/#{apache_name}/conf-enabled" do
          path "/etc/#{apache_name}/conf-enabled"
          owner 'root'
          group 'root'
          mode '0755'
          recursive true
          action :create
        end

        link "#{name} :create /etc/#{apache_name}/conf-enabled/#{config_name}.conf" do
          target_file "/etc/#{apache_name}/conf-enabled/#{config_name}.conf"
          to "/etc/#{apache_name}/conf-available/#{config_name}.conf"
          action :create
        end
      end
    end

    action :delete do
      if parsed_httpd_version.to_f < 2.4
        file "#{name} :delete /etc/#{apache_name}/conf.d/#{config_name}.conf" do
          path "/etc/#{apache_name}/conf.d/#{config_name}.conf"
          action :delete
        end
      else
        file "#{name} :delete /etc/#{apache_name}/conf-available/#{config_name}.conf" do
          path "/etc/#{apache_name}/conf-available/#{config_name}.conf"
          action :delete
        end

        link "#{name} :delete /etc/#{apache_name}/conf-enabled/#{config_name}.conf" do
          target_file "/etc/#{apache_name}/conf-enabled/#{config_name}.conf"
          to "/etc/#{apache_name}/conf-available/#{config_name}.conf"
          action :delete
        end
      end
    end

    include HttpdCookbook::Helpers::Debian
  end
end
