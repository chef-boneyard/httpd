require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class HttpdService
      class Docker < Chef::Provider::HttpdService
        action :create do         
          recipe_eval do
            run_context.include_recipe 'build-essential'
          end
          
          recipe_eval do
            run_context.include_recipe 'chef-metal'
          end

          chef_gem 'chef-metal-docker'
          
          machine 'wat' do
            driver 'docker'
            machine_options :docker_options => {              
              :base_image => {
                :name => 'busybox'
              },
              :command => 'nc -l -p 80'
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
