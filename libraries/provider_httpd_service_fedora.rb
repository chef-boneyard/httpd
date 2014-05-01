require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Fedora < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'fedora pattern' do

            log "Sorry, httpd_service support for #{node['platform']}-#{node['platform_version']} has not yet been implemented." do
              level :info
            end

          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :fedora, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Fedora
