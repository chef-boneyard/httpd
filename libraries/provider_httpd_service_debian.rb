require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Debian < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'debian pattern' do

            apache_version = new_resource.version

            package 'apache2' do
              action :install
            end

            template '/etc/apache2/apache2.conf' do
              source "debian/#{apache_version}/apache2.conf.erb"
              variables(:config => new_resource)
              cookbook 'httpd'
              action :create
            end

            service 'apache2' do
              action [:start, :enable]
              provider Chef::Provider::Service::Init::Debian
            end
          end
        end

        action :restart do
          converge_by 'debian pattern' do
            service 'apache2' do
              provider Chef::Provider::Service::Init::Debian
              supports :restart => true
              action :restart
            end
          end
        end

        action :reload do
          converge_by 'debian pattern' do
            service 'apache2' do
              provider Chef::Provider::Service::Init::Debian
              supports :reload => true
              action :reload
            end
          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :debian, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Debian
