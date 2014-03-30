require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class CrossplatThing
      class Ubuntu < Chef::Provider::CrossplatThing
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'ubuntu pattern' do

            log "Sorry, crossplat_thing support for #{node['platform']}-#{node['platform_version']} has not yet been implemented." do
              level :info
            end

          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :ubuntu, :resource => :crossplat_thing, :provider => Chef::Provider::CrossplatThing::Ubuntu
