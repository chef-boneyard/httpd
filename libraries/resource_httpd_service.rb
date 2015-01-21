class Chef
  class Resource
    class HttpdService < Chef::Resource::LWRPBase
      self.resource_name = :httpd_service
      actions :create, :delete, :start, :stop, :restart, :reload
      default_action :create

      attribute :contact, kind_of: String, default: 'webmaster@localhost'
      attribute :hostname_lookups, kind_of: String, default: 'off'
      attribute :instance, kind_of: String, name_attribute: true
      attribute :keepalive, kind_of: [TrueClass, FalseClass], default: true
      attribute :keepalivetimeout, kind_of: String, default: '5'
      attribute :listen_addresses, kind_of: [String, Array], default: ['0.0.0.0']
      attribute :listen_ports, kind_of: [String, Array], default: %w(80)
      attribute :log_level, kind_of: String, default: 'warn'
      attribute :maxclients, kind_of: String, default: nil
      attribute :maxconnectionsperchild, kind_of: String, default: nil
      attribute :maxkeepaliverequests, kind_of: String, default: '100'
      attribute :maxrequestsperchild, kind_of: String, default: nil
      attribute :maxrequestworkers, kind_of: String, default: nil
      attribute :maxspareservers, kind_of: String, default: nil
      attribute :maxsparethreads, kind_of: String, default: nil
      attribute :minspareservers, kind_of: String, default: nil
      attribute :minsparethreads, kind_of: String, default: nil
      attribute :modules, kind_of: Array, default: nil
      attribute :mpm, kind_of: String, default: nil
      attribute :package_name, kind_of: String, default: nil
      attribute :run_group, kind_of: String, default: nil
      attribute :run_user, kind_of: String, default: nil
      attribute :servername, kind_of: String, default: nil
      attribute :startservers, kind_of: String, default: nil
      attribute :threadlimit, kind_of: String, default: nil
      attribute :threadsperchild, kind_of: String, default: nil
      attribute :timeout, kind_of: String, default: '400'
      attribute :version, kind_of: String, default: nil
    end
  end
end
