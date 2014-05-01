require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class CrossplatThing
      class Rhel < Chef::Provider::CrossplatThing
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'rhel pattern' do

            log "Sorry, crossplat_thing support for #{node['platform']}-#{node['platform_version']} has not yet been implemented." do
              level :info
            end

          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :amazon, :resource => :crossplat_thing, :provider => Chef::Provider::CrossplatThing::Rhel
Chef::Platform.set :platform => :redhat, :resource => :crossplat_thing, :provider => Chef::Provider::CrossplatThing::Rhel
Chef::Platform.set :platform => :centos, :resource => :crossplat_thing, :provider => Chef::Provider::CrossplatThing::Rhel
Chef::Platform.set :platform => :oracle, :resource => :crossplat_thing, :provider => Chef::Provider::CrossplatThing::Rhel
Chef::Platform.set :platform => :scientific, :resource => :crossplat_thing, :provider => Chef::Provider::CrossplatThing::Rhel
