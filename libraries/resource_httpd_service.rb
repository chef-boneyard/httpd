require 'chef/resource/lwrp_base'
require_relative 'service_platform_info'
require_relative 'service_default_mpm_for'
require_relative 'service_default_value_for'

class Chef
  class Resource
    class HttpdService < Chef::Resource
      def initialize(name = nil, run_context = nil)
        super
        extend Httpd::Service::Helpers

        @resource_name = :httpd_service
        @service_name = name

        @action = :create
        @allowed_actions = [:create, :delete, :restart, :reload]

        @contact = 'webmaster@localhost'
        @hostname_lookups = 'off'
        @keepalive = true
        @keepaliverequests = '100'
        @keepalivetimeout = '5'
        @listen_addresses = ['0.0.0.0']
        @listen_ports = %w(80 443)
        @log_level = 'warn'

        @version = default_httpd_version_for(
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

        @mpm = default_mpm_for(
          @version
          )

        @startservers = default_value_for(@version, @mpm, :startservers)
        @minspareservers = default_value_for(@version, @mpm, :minspareservers)
        @maxspareservers = default_value_for(@version, @mpm, :maxspareservers)
        @maxclients = default_value_for(@version, @mpm, :maxclients)
        @maxrequestsperchild = default_value_for(@version, @mpm, :maxrequestsperchild)
        @minsparethreads = default_value_for(@version, @mpm, :minsparethreads)
        @maxsparethreads = default_value_for(@version, @mpm, :maxsparethreads)
        @threadlimit = default_value_for(@version, @mpm, :threadlimit)
        @threadsperchild = default_value_for(@version, @mpm, :threadsperchild)
        @maxrequestworkers = default_value_for(@version, @mpm, :maxrequestworkers)
        @maxconnectionsperchild = default_value_for(@version, @mpm, :maxconnectionsperchild)

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

      def mpm(arg = nil)
        set_or_return(
          :mpm,
          arg,
          :equal_to => %w(prefork worker event)
          )
      end

      def startservers(arg = nil)
        set_or_return(
          :startservers,
          arg,
          :callbacks => {
            'is not supported for version/mpm combination' => lambda do |_value|
              true unless default_value_for(version, mpm, :startservers).nil?
            end
          }
          )
      end

      def minspareservers(arg = nil)
        set_or_return(
          :minspareservers,
          arg,
          :callbacks => {
            'is not supported for version/mpm combination' => lambda do |_value|
              true unless default_value_for(version, mpm, :minspareservers).nil?
            end
          }
          )
      end

      def maxspareservers(arg = nil)
        set_or_return(
          :maxspareservers,
          arg,
          :callbacks => {
            'is not supported for version/mpm combination' => lambda do |_value|
              true unless default_value_for(version, mpm, :maxspareservers).nil?
            end
          }
          )
      end

      def maxclients(arg = nil)
        set_or_return(
          :maxclients,
          arg,
          :callbacks => {
            'is not supported for version/mpm combination' => lambda do |_value|
              true unless default_value_for(version, mpm, :maxclients).nil?
            end
          }
          )
      end

      def maxrequestsperchild(arg = nil)
        set_or_return(
          :maxrequestsperchild,
          arg,
          :callbacks => {
            'is not supported for version/mpm combination' => lambda do |_value|
              true unless default_value_for(version, mpm, :maxrequestsperchild).nil?
            end
          }
          )
      end

      def minsparethreads(arg = nil)
        set_or_return(
          :minsparethreads,
          arg,
          :callbacks => {
            'is not supported for version/mpm combination' => lambda do |_value|
              true unless default_value_for(version, mpm, :minsparethreads).nil?
            end
          }
          )
      end

      def maxsparethreads(arg = nil)
        set_or_return(
          :maxsparethreads,
          arg,
          :callbacks => {
            'is not supported for version/mpm combination' => lambda do |_value|
              true unless default_value_for(version, mpm, :maxsparethreads).nil?
            end
          }
          )
      end

      def threadlimit(arg = nil)
        set_or_return(
          :threadlimit,
          arg,
          :callbacks => {
            'is not supported for version/mpm combination' => lambda do |_value|
              true unless default_value_for(version, mpm, :threadlimit).nil?
            end
          }
          )
      end

      def threadsperchild(arg = nil)
        set_or_return(
          :threadsperchild,
          arg,
          :callbacks => {
            'is not supported for version/mpm combination' => lambda do |_value|
              true unless default_value_for(version, mpm, :threadsperchild).nil?
            end
          }
          )
      end

      def maxrequestworkers(arg = nil)
        set_or_return(
          :maxrequestworkers,
          arg,
          :callbacks => {
            'is not supported for version/mpm combination' => lambda do |_value|
              true unless default_value_for(version, mpm, :maxrequestworkers).nil?
            end
          }
          )
      end

      def maxconnectionsperchild(arg = nil)
        set_or_return(
          :maxconnectionsperchild,
          arg,
          :callbacks => {
            'is not supported for version/mpm combination' => lambda do |_value|
              true unless default_value_for(version, mpm, :maxconnectionsperchild).nil?
            end
          }
          )
      end
    end
  end
end
