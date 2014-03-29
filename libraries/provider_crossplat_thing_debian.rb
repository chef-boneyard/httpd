require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class CrossplatThing
      class Debian < Chef::Provider::CrossplatThing
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :create do
          converge_by 'debian pattern' do
            ruby_block 'hello' do
              puts "hello world\n"
            end
          end
        end
      end
    end
  end
end
