require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class CrossplatThing
      class Fedora < Chef::Provider::CrossplatThing
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'fedora pattern' do
            log "Sorry, crossplat_thing support for #{node['platform']}-#{node['platform_version']} has not yet been implemented." do
              level :info
            end
          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :fedora, :resource => :crossplat_thing, :provider => Chef::Provider::CrossplatThing::Fedora
