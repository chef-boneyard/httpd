module HttpdCookbook
  module Helpers
    def parsed_version
      return new_resource.version if new_resource.version
      default_apache_version
    end

    def parsed_httpd_version
      return new_resource.httpd_version if new_resource.httpd_version
      default_apache_version
    end

    def default_apache_version
      return '2.2' if node['platform_family'] == 'debian' && node['platform_version'] == '10.04'
      return '2.2' if node['platform_family'] == 'debian' && node['platform_version'] == '12.04'
      return '2.2' if node['platform_family'] == 'debian' && node['platform_version'] == '13.04'
      return '2.2' if node['platform_family'] == 'debian' && node['platform_version'] == '13.10'
      return '2.2' if node['platform_family'] == 'debian' && node['platform_version'].to_i == 6
      return '2.2' if node['platform_family'] == 'debian' && node['platform_version'].to_i == 7
      return '2.2' if node['platform_family'] == 'freebsd'
      return '2.2' if node['platform_family'] == 'omnios'
      return '2.2' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 5
      return '2.2' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 6
      return '2.2' if node['platform_family'] == 'suse'
      return '2.4' if node['platform_family'] == 'debian' && node['platform_version'] == '14.04'
      return '2.4' if node['platform_family'] == 'debian' && node['platform_version'] == '14.10'
      return '2.4' if node['platform_family'] == 'debian' && node['platform_version'] == 'jessie/sid'
      return '2.4' if node['platform_family'] == 'fedora'
      return '2.4' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 2013
      return '2.4' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 2014
      return '2.4' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 7
      return '2.4' if node['platform_family'] == 'smartos'
    end

    def parsed_symbolname
      return new_resource.symbolname if new_resource.symbolname
      # Put all exceptions here
      return 'php5_module' if module_name == 'php'
      return 'php5_module' if module_name == 'php-zts'
      "#{module_name}_module"
    end

    def parsed_filename
      return new_resource.filename if new_resource.filename
      # Put all exceptions here
      if node['platform_family'] == 'rhel'
        return 'libmodnss.so' if module_name == 'nss'
        return 'mod_rev.so' if module_name == 'revocator'
        return 'libphp5.so' if module_name == 'php'
        return 'libphp5-zts.so' if module_name == 'php-zts'
      end
      "mod_#{module_name}.so"
    end

    def parsed_module_package_name
      return new_resource.package_name if new_resource.package_name
      package_name_for_module(
        module_name,
        parsed_httpd_version,
        node['platform'],
        node['platform_family'],
        node['platform_version']
        )
    end

    def parsed_service_package_name
      return new_resource.package_name if new_resource.package_name
      package_name_for_service(
        node['platform'],
        node['platform_family'],
        node['platform_version'],
        parsed_version
        )
    end

    def parsed_maxclients
      return new_resource.maxclients if new_resource.maxclients
      default_value_for(parsed_version, parsed_mpm, :maxclients)
    end

    def parsed_maxconnectionsperchild
      return new_resource.maxconnectionsperchild if new_resource.maxconnectionsperchild
      default_value_for(parsed_version, parsed_mpm, :maxconnectionsperchild)
    end

    def parsed_maxrequestsperchild
      return new_resource.maxrequestsperchild if new_resource.maxrequestsperchild
      default_value_for(parsed_version, parsed_mpm, :maxrequestsperchild)
    end

    def parsed_maxrequestworkers
      return new_resource.maxrequestworkers if new_resource.maxrequestworkers
      default_value_for(parsed_version, parsed_mpm, :maxrequestworkers)
    end

    def parsed_maxspareservers
      return new_resource.maxspareservers if new_resource.maxspareservers
      default_value_for(parsed_version, parsed_mpm, :maxspareservers)
    end

    def parsed_maxsparethreads
      return new_resource.maxsparethreads if new_resource.maxsparethreads
      default_value_for(parsed_version, parsed_mpm, :maxsparethreads)
    end

    def parsed_minspareservers
      return new_resource.minspareservers if new_resource.minspareservers
      default_value_for(parsed_version, parsed_mpm, :minspareservers)
    end

    def parsed_minsparethreads
      return new_resource.minsparethreads if new_resource.minsparethreads
      default_value_for(parsed_version, parsed_mpm, :minsparethreads)
    end

    def parsed_modules
      return new_resource.modules if new_resource.modules
      return %w(
        alias autoindex dir
        env mime negotiation
        setenvif status auth_basic
        deflate authz_default
        authz_user authz_groupfile
        authn_file authz_host
        reqtimeout
      ) if parsed_version == '2.2'

      return %w(
        authz_core authz_host authn_core
        auth_basic access_compat authn_file
        authz_user alias dir autoindex
        env mime negotiation setenvif
        filter deflate status
      ) if parsed_version == '2.4'
    end

    def parsed_mpm
      return new_resource.mpm if new_resource.mpm
      parsed_version == '2.4' ? 'event' : 'worker'
    end

    def parsed_run_group
      return new_resource.run_group if new_resource.run_group
      node['platform_family'] == 'debian' ? 'www-data' : 'apache'
    end

    def parsed_run_user
      return new_resource.run_user if new_resource.run_user
      node['platform_family'] == 'debian' ? 'www-data' : 'apache'
    end

    def parsed_servername
      return new_resource.servername if new_resource.servername
      node['hostname']
    end

    def parsed_startservers
      return new_resource.startservers if new_resource.startservers
      default_value_for(parsed_version, parsed_mpm, :startservers)
    end

    def parsed_threadlimit
      return new_resource.threadlimit if new_resource.threadlimit
      default_value_for(parsed_version, parsed_mpm, :threadlimit)
    end

    def parsed_threadsperchild
      return new_resource.threadsperchild if new_resource.threadsperchild
      default_value_for(parsed_version, parsed_mpm, :threadsperchild)
    end
  end
end
