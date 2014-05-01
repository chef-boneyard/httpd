require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Rhel < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'rhel pattern' do

            log "Sorry, httpd_service support for #{node['platform']}-#{node['platform_version']} has not yet been implemented." do
              level :info
            end

          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :amazon, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel
Chef::Platform.set :platform => :redhat, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel
Chef::Platform.set :platform => :centos, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel
Chef::Platform.set :platform => :oracle, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel
Chef::Platform.set :platform => :scientific, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Rhel
