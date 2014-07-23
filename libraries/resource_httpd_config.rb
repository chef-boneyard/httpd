require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class HttpdConfig < Chef::Resource
      def initialize(name = nil, run_context = nil)
        super

        @resource_name = :httpd_config
        @config_name = name
        @action = :create
        @allowed_actions = [:create, :delete]

        @instance = 'default'
        @source = nil
        @cookbook = nil
      end

      def config_name(arg = nil)
        set_or_return(
          :config_name,
          arg,
          :kind_of => String
          )
      end

      def instance(arg = nil)
        set_or_return(
          :instance,
          arg,
          :kind_of => String
          )
      end

      def source(arg = nil)
        set_or_return(
          :source,
          arg,
          :kind_of => String
          )
      end

      def cookbook(arg = nil)
        set_or_return(
          :cookbook,
          arg,
          :kind_of => String
          )
      end
    end
  end
end
