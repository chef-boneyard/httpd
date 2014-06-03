 require 'chef/resource/lwrp_base'
 require_relative 'helpers'

 class Chef
   class Resource
     class HttpdService < Chef::Resource
       def initialize(name = nil, run_context = nil)
         super
         extend Opscode::Httpd::Helpers

         @action = :create
         @allowed_actions = [:create, :restart, :reload]

         @contact = 'webmaster@localhost'
         @hostname_lookups = 'off'
         @keepalive = true
         @keepaliverequests = '100'
         @keepalivetimeout = '5'
         @listen_addresses = nil
         @listen_ports = %w(80 443)
         @log_level = 'warn'

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

       # attribute :contact, kind_of: String
       def contact(arg = nil)
         set_or_return(
           :contact,
           arg,
           :kind_of => String
           )
       end

       # attribute :hostname_lookups, kind_of: %w(on off double)
       def hostname_lookups(arg = nil)
         set_or_return(
           :hostname_lookups,
           arg,
           :kind_of => %w(on off double)
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

       # attribute :listen_addresses, kind_of: String
       def listen_addresses(arg = nil)
         set_or_return(
           :listen_addresses,
           arg,
           :kind_of => [String, Array]
           )
       end

       # attribute :listen_ports, kind_of: String
       def listen_ports(arg = nil)
         set_or_return(
           :listen_ports,
           arg,
           :kind_of => [Chef::Node::ImmutableArray, String, Array]
           )
       end

       # attribute :log_level, kind_of: String
       def log_level(arg = nil)
         set_or_return(
           :log_level,
           arg,
           :equal_to => %w(emerg alert crit error warn notice info debug)
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

       # attribute :run_user, kind_of: String
       def run_user(arg = nil)
         set_or_return(
           :run_user,
           arg,
           :kind_of => String
           )
       end

       # attribute :run_group, kind_of: String
       def run_group(arg = nil)
         set_or_return(
           :run_group,
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
     end
   end
 end
