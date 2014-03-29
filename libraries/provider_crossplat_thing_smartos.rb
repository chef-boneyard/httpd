require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class CrossplatThing
      class Smartos < Chef::Provider::CrossplatThing
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'smartos pattern' do
            ruby_block "message for #{node['platform']}-#{node['platform_version']}" do
              block do
                puts "Support for #{node['platform']}-#{node['platform_version']} has not yet been implemented"
              end
              action :run
            end
          end
        end
      end
    end
  end
end

Chef::Platform.set :platform => :smartos, :resource => :crossplat_thing, :provider => Chef::Provider::CrossplatThing::Smartos
