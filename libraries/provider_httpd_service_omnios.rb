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
          converge_by 'omnios pattern' do

            package 'apache22' do
              action :install
            end

          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :omnios, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Omnios
