require 'chef/resource/lwrp_base'
require_relative 'helpers'

class Chef
  class Resource
    class HttpdService < Chef::Resource
      def initialize(name = nil, run_context = nil)
        super
        extend Opscode::Httpd::Helpers

        @action = :create
        @allowed_actions = [:create, :delete, :restart, :reload]

        @contact = 'webmaster@localhost'
        @hostname_lookups = 'off'
        @keepalive = true
        @keepaliverequests = '100'
        @keepalivetimeout = '5'
        @listen_addresses = nil
        @listen_ports = %w(80 443)
        @log_level = 'warn'
        @mpm = 'event'

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

        @resource_name = :httpd_service

        @run_user = default_run_user_for(
          node['platform'],
          node['platform_family'],
          node['platform_version']
          )

        @run_group = default_run_user_for(
          node['platform'],
          node['platform_family'],
          node['platform_version']
          )

        @service_name = name
        @timeout = '400'
      end

      def contact(arg = nil)
        set_or_return(
          :contact,
          arg,
          :kind_of => String
          )
      end

      def hostname_lookups(arg = nil)
        set_or_return(
          :hostname_lookups,
          arg,
          :kind_of => %w(on off double)
          )
      end

      def keepalive(arg = nil)
        set_or_return(
          :keepalive,
          arg,
          :kind_of => [TrueClass, FalseClass]
          )
      end

      def keepaliverequests(arg = nil)
        set_or_return(
          :keepaliverequests,
          arg,
          :kind_of => String
          )
      end

      def keepalivetimeout(arg = nil)
        set_or_return(
          :keepalivetimeout,
          arg,
          :kind_of => String
          )
      end

      def listen_addresses(arg = nil)
        set_or_return(
          :listen_addresses,
          arg,
          :kind_of => [String, Array]
          )
      end

      def listen_ports(arg = nil)
        set_or_return(
          :listen_ports,
          arg,
          :kind_of => [Chef::Node::ImmutableArray, String, Array]
          )
      end

      def log_level(arg = nil)
        set_or_return(
          :log_level,
          arg,
          :equal_to => %w(emerg alert crit error warn notice info debug)
          )
      end

      def mpm(arg = nil)
        set_or_return(
          :mpm,
          arg,
          :kind_of => %w(prefork worker event)
          )
      end

      def package_name(arg = nil)
        set_or_return(
          :package_name,
          arg,
          :kind_of => String
          )
      end

      def run_user(arg = nil)
        set_or_return(
          :run_user,
          arg,
          :kind_of => String
          )
      end

      def run_group(arg = nil)
        set_or_return(
          :run_group,
          arg,
          :kind_of => String
          )
      end

      def timeout(arg = nil)
        set_or_return(
          :timeout,
          arg,
          :kind_of => String
          )
      end

      def version(arg = nil)
        package_name package_name_for(
          node['platform'],
          node['platform_family'],
          node['platform_version'],
          arg
          )

        set_or_return(
          :version,
          arg,
          :kind_of => String,
          :callbacks => {
            "is not supported for #{node['platform']}-#{node['platform_version']}" => lambda do |_httpd_version|
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
    end
  end
end
