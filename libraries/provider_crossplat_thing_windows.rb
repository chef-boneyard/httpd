require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class CrossplatThing
      class Windows < Chef::Provider::CrossplatThing
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'windows pattern' do
            # FIXME: weird.. goes in as 2008R2, comes out as 6.1.7600
            ruby_block 'message for windows-6.1.7600' do
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

Chef::Platform.set :platform => :windows, :resource => :crossplat_thing, :provider => Chef::Provider::CrossplatThing::Windows
