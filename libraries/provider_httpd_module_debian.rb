require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdModule
      class Debian < Chef::Provider::HttpdModule
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :install do
          converge_by 'debian pattern' do
          end
        end

        action :remove do
          converge_by 'debian pattern' do
          end
        end
        
      end
    end
  end
end
