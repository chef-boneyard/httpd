require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Omnios < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          # wat
        end
        action :delete do
          # wat
        end
      end
    end
  end
end

Chef::Platform.set :platform => :omnios, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Omnios
