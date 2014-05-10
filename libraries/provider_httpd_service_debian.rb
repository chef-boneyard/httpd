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

            package 'apache2' do
              action :install
            end

            template '/etc/apache2/apache2.conf' do
              action :create
              cookbook 'httpd'
            end

            service 'apache2' do
              action [:start, :enable]
            end
            
          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :debian, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Debian
