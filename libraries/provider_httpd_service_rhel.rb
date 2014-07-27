require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Rhel < Chef::Provider::HttpdService
        action :create do
        end

        action :delete do
        end

        action :restart do
        end

        action :reload do
        end
      end
    end
  end
end
