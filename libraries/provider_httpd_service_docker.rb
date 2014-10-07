require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Docker < Chef::Provider::HttpdService
        action :create do
          recipe_eval do
            run_context.include_recipe 'build-essential'
          end

          chef_gem 'chef-metal'
          chef_gem 'chef-metal-docker'
          
          require 'chef_metal'
          require 'chef_metal_docker'

          machine 'wat' do
            driver 'docker'
            action :setup
            machine_options :docker_options => {
              :base_image => {
                :name => 'busybox',
                :repository => 'busybox',
              },
              :command => 'nc -l -p 8080',
              :ports => [ '80:8080']
            }
          end
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
