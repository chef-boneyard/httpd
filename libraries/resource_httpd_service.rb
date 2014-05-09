require 'chef/resource/lwrp_base'
require_relative 'helpers'

class Chef
  class Resource
    class HttpdService < Chef::Resource
      # Initialize resource
      def initialize(name = nil, run_context = nil)
        super
        extend Opscode::Httpd::Helpers
        @resource_name = :httpd_service
        @service_name = name

        @allowed_actions = [:create, :restart, :reload]
        @action = :create

        # set default values
        @version = default_version_for(
          node['platform'],
          node['platform_family'],
          node['platform_version']
          )

        @package_name = package_name_for(
          node['platform'],
          node['platform_family'],
          node['platform_version'],
          @version
          )

        @listen_addresses = nil
        @listen_ports = %w(80 443)
        @contact = 'webmaster@localhost'
        @timeout = '400'
        @keepalive = true
        @keepaliverequests = '100'
        @keepalivetimeout = '5'
      end

      # attribute :version, kind_of: String
      def version(arg = nil)
        # First, set the package_name to the appropriate value.
        package_name package_name_for(
          node['platform'],
          node['platform_family'],
          node['platform_version'],
          arg
          )

        # Then, validate and return the version number.
        set_or_return(
          :version,
          arg,
          :kind_of => String,
          :callbacks => {
            "is not supported for #{node['platform']}-#{node['platform_version']}" => lambda do |httpd_version|
              true unless package_name_for(
                node['platform'],
                node['platform_family'],
                node['platform_version'],
                arg
                ).nil?
            end
          }
          )
      end

      # attribute :package_name, kind_of: String
      def package_name(arg = nil)
        set_or_return(
          :package_name,
          arg,
          :kind_of => String
          )
      end

      # attribute :listen_addresses, kind_of: String
      def listen_addresses(arg = nil)
        set_or_return(
          :listen_addresses,
          arg,
          :kind_of => [String]
          )
      end

      # attribute :listen_ports, kind_of: String
      def listen_ports(arg = nil)
        set_or_return(
          :listen_ports,
          arg,
          :kind_of => [String]
          )
      end

      # attribute :contact, kind_of: String
      def contact(arg = nil)
        set_or_return(
          :contact,
          arg,
          :kind_of => String
          )
      end

      # attribute :timeout, kind_of: String
      def timeout(arg = nil)
        set_or_return(
          :timeout,
          arg,
          :kind_of => String
          )
      end

      # attribute :keepalive, kind_of: [TrueClass,FalseClass]
      def keepalive(arg = nil)
        set_or_return(
          :keepalive,
          arg,
          :kind_of => [TrueClass, FalseClass]
          )
      end

      # attribute :keepaliverequests, kind_of: String
      def keepaliverequests(arg = nil)
        set_or_return(
          :keepaliverequests,
          arg,
          :kind_of => String
          )
      end

      # attribute :keepalivetimeout, kind_of: String
      def keepalivetimeout(arg = nil)
        set_or_return(
          :keepalivetimeout,
          arg,
          :kind_of => String
          )
      end
    end
  end
end
