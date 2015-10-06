module HttpdCookbook
  class HttpdService < ChefCompat::Resource
    property :contact, String, default: 'webmaster@localhost'
    property :hostname_lookups, String, default: 'off'
    property :instance, String, name_property: true
    property :keepalive, [TrueClass, FalseClass], default: true
    property :keepalivetimeout, [String, nil], default: '5'
    property :listen_addresses, [String, Array, nil], default: ['0.0.0.0']
    property :listen_ports, [String, Array, nil], default: %w(80)
    property :log_level, [String, nil], default: 'warn'
    property :maxclients, [String, nil], default: nil
    property :maxconnectionsperchild, [String, nil], default: nil
    property :maxkeepaliverequests, [String, nil], default: '100'
    property :maxrequestsperchild, [String, nil], default: nil
    property :maxrequestworkers, [String, nil], default: nil
    property :maxspareservers, [String, nil], default: nil
    property :maxsparethreads, [String, nil], default: nil
    property :minspareservers, [String, nil], default: nil
    property :minsparethreads, [String, nil], default: nil
    property :modules, [Array, nil], default: nil
    property :mpm, [String, nil], default: nil
    property :package_name, [String, nil], default: nil
    property :run_group, String, default: nil
    property :run_user, [String, nil], default: nil
    property :servername, [String, nil], default: nil
    property :startservers, [String, nil], default: nil
    property :threadlimit, [String, nil], default: nil
    property :threadsperchild, [String, nil], default: nil
    property :timeout, [String, nil], default: '400'
    property :version, String, default: lazy { default_apache_version }

    include HttpdCookbook::Helpers
  end
end
