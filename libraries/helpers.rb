require 'chef_compat/resource'

module HttpdCookbook
  module Helpers
    def parsed_version
      return version if version
      default_apache_version
    end

    def parsed_httpd_version
      return httpd_version if httpd_version
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
      return '2.4' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 2015
      return '2.4' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 7
      return '2.4' if node['platform_family'] == 'smartos'
    end

    def parsed_symbolname
      return symbolname if symbolname
      # Put all exceptions here
      return 'php5_module' if module_name == 'php'
      return 'php5_module' if module_name == 'php-zts'
      "#{module_name}_module"
    end

    def parsed_filename
      return filename if filename
      # Put all exceptions here
      case node['platform_family']
      when 'debian'
        return 'libphp5.so' if module_name == 'php5'
      when 'rhel'
        return 'libmodnss.so' if module_name == 'nss'
        return 'mod_rev.so' if module_name == 'revocator'
        return 'libphp5.so' if module_name == 'php'
        return 'libphp5-zts.so' if module_name == 'php-zts'
      end
      "mod_#{module_name}.so"
    end

    def parsed_module_package_name
      return package_name if package_name
      package_name_for_module(
        module_name,
        parsed_httpd_version,
        node['platform'],
        node['platform_family'],
        node['platform_version']
      )
    end

    def parsed_service_package_name
      return package_name if package_name
      package_name_for_service(
        node['platform'],
        node['platform_family'],
        node['platform_version'],
        parsed_version
      )
    end

    def parsed_maxclients
      return maxclients if maxclients
      default_value_for(parsed_version, parsed_mpm, :maxclients)
    end

    def parsed_maxconnectionsperchild
      return maxconnectionsperchild if maxconnectionsperchild
      default_value_for(parsed_version, parsed_mpm, :maxconnectionsperchild)
    end

    def parsed_maxrequestsperchild
      return maxrequestsperchild if maxrequestsperchild
      default_value_for(parsed_version, parsed_mpm, :maxrequestsperchild)
    end

    def parsed_maxrequestworkers
      return maxrequestworkers if maxrequestworkers
      default_value_for(parsed_version, parsed_mpm, :maxrequestworkers)
    end

    def parsed_maxspareservers
      return maxspareservers if maxspareservers
      default_value_for(parsed_version, parsed_mpm, :maxspareservers)
    end

    def parsed_maxsparethreads
      return maxsparethreads if maxsparethreads
      default_value_for(parsed_version, parsed_mpm, :maxsparethreads)
    end

    def parsed_minspareservers
      return minspareservers if minspareservers
      default_value_for(parsed_version, parsed_mpm, :minspareservers)
    end

    def parsed_minsparethreads
      return minsparethreads if minsparethreads
      default_value_for(parsed_version, parsed_mpm, :minsparethreads)
    end

    def parsed_modules
      return modules if modules
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
      return mpm if mpm
      parsed_version == '2.4' ? 'event' : 'worker'
    end

    def parsed_run_group
      return run_group if run_group
      node['platform_family'] == 'debian' ? 'www-data' : 'apache'
    end

    def parsed_run_user
      return run_user if run_user
      node['platform_family'] == 'debian' ? 'www-data' : 'apache'
    end

    def parsed_servername
      return servername if servername
      node['hostname']
    end

    def parsed_startservers
      return startservers if startservers
      default_value_for(parsed_version, parsed_mpm, :startservers)
    end

    def parsed_threadlimit
      return threadlimit if threadlimit
      default_value_for(parsed_version, parsed_mpm, :threadlimit)
    end

    def parsed_threadsperchild
      return threadsperchild if threadsperchild
      default_value_for(parsed_version, parsed_mpm, :threadsperchild)
    end
  end
end
