require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Ubuntu < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'ubuntu pattern' do
            # wat
          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :ubuntu, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Ubuntu
