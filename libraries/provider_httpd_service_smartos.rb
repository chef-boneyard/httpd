require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Smartos < Chef::Provider::HttpdService
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'smartos pattern' do

            package 'apache' do
              action :install
            end

          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :smartos, :resource => :httpd_service, :provider => Chef::Provider::HttpdService::Smartos
