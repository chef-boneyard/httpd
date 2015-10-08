module HttpdCookbook
  class HttpdService < ChefCompat::Resource
    property :contact, String, default: 'webmaster@localhost'
    property :hostname_lookups, String, default: 'off'
    property :instance, String, name_property: true
    property :keepalive, [TrueClass, FalseClass], default: true
    property :keepalivetimeout, String, default: '5'
    property :listen_addresses, [String, Array], default: ['0.0.0.0']
    property :listen_ports, [String, Array], default: %w(80)
    property :log_level, String, default: 'warn'
    property :version, String, default: lazy { default_apache_version }
    property :maxclients, String, default: lazy { default_maxclients }
    property :maxconnectionsperchild, String, default: lazy { default_maxconnectionsperchild }
    property :maxkeepaliverequests, String, default: '100'
    property :maxrequestsperchild, String, default: lazy { default_maxrequestsperchild }
    property :maxrequestworkers, String, default: lazy { default_maxrequestworkers }
    property :maxspareservers, String, default: lazy { default_maxspareservers }
    property :maxsparethreads, String, default: lazy { default_maxsparethreads }
    property :minspareservers, String, default: lazy { default_minspareservers }
    property :minsparethreads, String, default: lazy { default_minsparethreads }
    property :modules, Array, default: lazy { default_modules }
    property :mpm, String, default: lazy { default_mpm }
    property :package_name, String, default: lazy { default_package_name }
    property :run_group, String, default: lazy { default_run_group }
    property :run_user, String, default: lazy { default_run_user }
    property :servername, String, default: lazy { node['hostname'] }
    property :startservers, String, default: lazy { default_startservers }
    property :threadlimit, String, default: lazy { default_threadlimit }
    property :threadsperchild, String, default: lazy { default_threadsperchild }
    property :timeout, String, default: '400'

    include HttpdCookbook::Helpers
  end
end
