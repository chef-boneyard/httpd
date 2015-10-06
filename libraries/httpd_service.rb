module HttpdCookbook
  class HttpdService < ChefCompat::Resource
    property :contact, kind_of: String, default: 'webmaster@localhost'
    property :hostname_lookups, kind_of: String, default: 'off'
    property :instance, kind_of: String, name_property: true
    property :keepalive, kind_of: [TrueClass, FalseClass], default: true
    property :keepalivetimeout, kind_of: String, default: '5'
    property :listen_addresses, kind_of: [String, Array], default: ['0.0.0.0']
    property :listen_ports, kind_of: [String, Array], default: %w(80)
    property :log_level, kind_of: String, default: 'warn'
    property :maxclients, kind_of: String, default: nil
    property :maxconnectionsperchild, kind_of: String, default: nil
    property :maxkeepaliverequests, kind_of: String, default: '100'
    property :maxrequestsperchild, kind_of: String, default: nil
    property :maxrequestworkers, kind_of: String, default: nil
    property :maxspareservers, kind_of: String, default: nil
    property :maxsparethreads, kind_of: String, default: nil
    property :minspareservers, kind_of: String, default: nil
    property :minsparethreads, kind_of: String, default: nil
    property :modules, kind_of: Array, default: nil
    property :mpm, kind_of: String, default: nil
    property :package_name, kind_of: String, default: nil
    property :run_group, kind_of: String, default: nil
    property :run_user, kind_of: String, default: nil
    property :servername, kind_of: String, default: nil
    property :startservers, kind_of: String, default: nil
    property :threadlimit, kind_of: String, default: nil
    property :threadsperchild, kind_of: String, default: nil
    property :timeout, kind_of: String, default: '400'
    property :version, kind_of: String, default: nil

    declare_action_class.class_eval { include HttpdCookbook::Helpers }
  end
end
