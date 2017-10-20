module HttpdCookbook
  module Helpers
    def default_apache_version
      return '2.2' if node['platform_family'] == 'debian' && node['platform_version'].to_i == 7
      return '2.2' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 6
      return '2.4' if node['platform_family'] == 'debian' && node['platform_version'].to_i >= 8
      return '2.4' if node['platform_family'] == 'fedora'
      return '2.4' if node['platform_family'] == 'freebsd'
      return '2.4' if node['platform_family'] == 'suse'
      return '2.4' if node['platform_family'] == 'rhel' && node['platform_version'].to_i >= 7
      return '2.4' if node['platform'] == 'amazon'
      return '2.4' if node['platform'] == 'ubuntu'
    end

    def default_maxclients
      default_value_for(version, mpm, :maxconnectionsperchild)
    end

    def default_maxconnectionsperchild
      default_value_for(version, mpm, :maxconnectionsperchild)
    end

    def default_maxrequestsperchild
      default_value_for(version, mpm, :maxrequestsperchild)
    end

    def default_maxrequestworkers
      default_value_for(version, mpm, :maxrequestworkers)
    end

    def default_maxspareservers
      default_value_for(version, mpm, :maxspareservers)
    end

    def default_maxsparethreads
      default_value_for(version, mpm, :maxsparethreads)
    end

    def default_minspareservers
      default_value_for(version, mpm, :minspareservers)
    end

    def default_minsparethreads
      default_value_for(version, mpm, :minsparethreads)
    end

    def default_startservers
      default_value_for(version, mpm, :startservers)
    end

    def default_threadlimit
      default_value_for(version, mpm, :threadlimit)
    end

    def default_threadsperchild
      default_value_for(version, mpm, :threadsperchild)
    end

    def default_modules
      return %w(
        alias autoindex dir
        env mime negotiation
        setenvif status auth_basic
        deflate authz_default
        authz_user authz_groupfile
        authn_file authz_host
        reqtimeout
      ) if version == '2.2'

      return %w(
        authz_core authz_host authn_core
        auth_basic access_compat authn_file
        authz_user alias dir autoindex
        env mime negotiation setenvif
        filter deflate status
      ) if version == '2.4'
    end

    def default_mpm
      version == '2.4' ? 'event' : 'worker'
    end

    def default_package_name
      package_name_for_service(
        node['platform'],
        node['platform_family'],
        node['platform_version'],
        version
      )
    end

    def default_run_group
      case node['platform_family']
      when 'debian'
        'www-data'
      when 'suse'
        'www'
      else
        'apache'
      end
    end

    def default_run_user
      case node['platform_family']
      when 'debian'
        'www-data'
      when 'suse'
        'wwwrun'
      else
        'apache'
      end
    end

    def config_file_relative_path
      case node['platform_family']
      when 'debian'
        'apache2.conf'
      else
        'conf/httpd.conf'
      end
    end
  end
end
