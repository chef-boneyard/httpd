require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Docker < Chef::Provider::HttpdService
        action :create do
          docker_image 'busybox'
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
