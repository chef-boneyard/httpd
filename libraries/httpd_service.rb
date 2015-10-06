module HttpdCookbook
  class HttpdService < ChefCompat::Resource
    property :contact, kind_of: String, default: 'webmaster@localhost'
    property :hostname_lookups, kind_of: String, default: 'off'
    property :instance, kind_of: String, name_property: true
    property :keepalive, kind_of: [TrueClass, FalseClass], default: true
    property :keepalivetimeout, kind_of: [String, NilClass], default: '5'
    property :listen_addresses, kind_of: [String, Array, NilClass], default: ['0.0.0.0']
    property :listen_ports, kind_of: [String, Array, NilClass], default: %w(80)
    property :log_level, kind_of: [String, NilClass], default: 'warn'
    property :maxclients, kind_of: [String, NilClass], default: nil
    property :maxconnectionsperchild, kind_of: [String, NilClass], default: nil
    property :maxkeepaliverequests, kind_of: [String, NilClass], default: '100'
    property :maxrequestsperchild, kind_of: [String, NilClass], default: nil
    property :maxrequestworkers, kind_of: [String, NilClass], default: nil
    property :maxspareservers, kind_of: [String, NilClass], default: nil
    property :maxsparethreads, kind_of: [String, NilClass], default: nil
    property :minspareservers, kind_of: [String, NilClass], default: nil
    property :minsparethreads, kind_of: [String, NilClass], default: nil
    property :modules, kind_of: [Array, NilClass], default: nil
    property :mpm, kind_of: [String, NilClass], default: nil
    property :package_name, kind_of: [String, NilClass], default: nil
    property :run_group, kind_of: String, default: nil
    property :run_user, kind_of: [String, NilClass], default: nil
    property :servername, kind_of: [String, NilClass], default: nil
    property :startservers, kind_of: [String, NilClass], default: nil
    property :threadlimit, kind_of: [String, NilClass], default: nil
    property :threadsperchild, kind_of: [String, NilClass], default: nil
    property :timeout, kind_of: [String, NilClass], default: '400'
    property :version, kind_of: [String, NilClass], default: nil

    declare_action_class.class_eval { include HttpdCookbook::Helpers }
  end
end
