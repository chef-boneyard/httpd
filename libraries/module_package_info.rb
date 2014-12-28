require_relative 'module_package_info_dsl'

module Httpd
  module Module
    module Helpers
      def keyname_for(platform, platform_family, platform_version)
        if platform_family == 'rhel' && platform != 'amazon'
          major_version(platform_version)
        elsif platform_family == 'debian' && !(platform == 'ubuntu' || platform_version =~ /sid$/)
          major_version(platform_version)
        elsif platform_family == 'freebsd'
          major_version(platform_version)
        else
          platform_version
        end
      end

      def major_version(version)
        version.to_i.to_s
      end

      def package_name_for_module(name, httpd_version, platform, platform_family, platform_version)
        ModuleInfo.find(
          module: name,
          httpd_version: httpd_version,
          platform: platform,
          platform_family: platform_family,
          platform_version: keyname_for(platform, platform_family, platform_version)
          )
      end

      class ModuleInfo
        extend ModuleInfoDSL

        #
        # debian packaging for apache 2.2
        #
        modules for: { platform_family: 'debian', httpd_version: '2.2' },
                are: %w(
                  actions alias asis auth_basic auth_digest authn_alias authn_anon
                  authn_dbd authn_dbm authn_default authn_file authnz_ldap authz_dbm
                  authz_default authz_groupfile authz_host authz_owner authz_user
                  autoindex cache cern_meta cgid cgi charset_lite dav_fs dav_lock dav
                  dbd deflate dir disk_cache dumpio env expires ext_filter file_cache
                  filter headers ident imagemap include info ldap log_forensic mem_cache
                  mime_magic mime negotiation proxy_ajp proxy_balancer proxy_connect
                  proxy_ftp proxy_http proxy_scgi proxy reqtimeout rewrite setenvif
                  speling ssl status substitute suexec unique_id userdir usertrack
                  vhost_alias
                ),
                found_in_package: 'apache2'

        modules for: { platform_family: 'debian', httpd_version: '2.2' },
                are: %w(
                  apparmor apreq2 auth_cas auth_kerb auth_memcookie auth_mysql
                  auth_ntlm_winbind auth_openid auth_pam auth_pgsql auth_plain
                  auth_pubtkt auth_radius auth_sys_group auth_tkt authn_sasl authn_webid
                  authn_yubikey authnz_external authz_unixgroup bw dacs defensible dnssd
                  encoding evasive fcgid fcgid_dbg geoip gnutls jk layout ldap_userdir
                  ldap_userdir_dbg lisp log_sql log_sql_dbi log_sql_mysql log_sql_ssl
                  macro mime_xattr modsecurity mono musicindex neko nss ocamlnet parser3
                  passenger perl2 perl2_dev perl2_doc php5 php5filter proxy_html python
                  python_doc qos random removeip rivet rivet_doc rpaf ruby ruid2 ruwsgi
                  ruwsgi_dbg scgi shib2 spamhaus speedycgi suphp upload_progress uwsgi
                  uwsgi_dbg vhost_hash_alias vhost_ldap wsgi wsgi_py3 xsendfile
                ),
                found_in_package: ->(name) { "libapache2-mod-#{name.gsub('_', '-')}" }

        #
        # debian packaging for apache 2.4
        #
        modules for: { platform_family: 'debian', httpd_version: '2.4' },
                are: %w(
                  access_compat actions alias allowmethods asis auth_basic
                  auth_digest auth_form authn_anon authn_core authn_dbd authn_dbm
                  authn_file authn_socache authnz_ldap authz_core authz_dbd authz_dbm
                  authz_groupfile authz_host authz_owner authz_user autoindex buffer
                  cache cache_disk cache_socache cgi cgid charset_lite data dav
                  dav_fs dav_lock dbd deflate dialup dir dumpio echo env expires
                  ext_filter file_cache filter headers heartbeat heartmonitor include
                  info lbmethod_bybusyness lbmethod_byrequests lbmethod_bytraffic
                  lbmethod_heartbeat ldap log_debug log_forensic macro mime mime_magic
                  mpm_event mpm_prefork mpm_worker negotiation proxy proxy_ajp
                  proxy_balancer proxy_connect proxy_express proxy_fcgi proxy_fdpass
                  proxy_ftp proxy_html proxy_http proxy_scgi proxy_wstunnel ratelimit
                  reflector remoteip reqtimeout request rewrite sed session
                  session_cookie session_crypto session_dbd setenvif slotmem_plain
                  slotmem_shm socache_dbm socache_memcache socache_shmcb speling ssl
                  status substitute suexec unique_id userdir usertrack vhost_alias
                  xml2enc
                ),
                found_in_package: 'apache2'

        modules for: { platform_family: 'debian', httpd_version: '2.4' },
                are: %w(
                  apparmor auth_mysql auth_pgsql auth_plain perl2 perl2_dev
                  perl2_doc php5 python python_doc wsgi reload_perl fastcgi
                  authcassimple_perl authcookie_perl authenntlm_perl apreq2 auth_cas
                  auth_kerb auth_mellon auth_memcookie auth_ntlm_winbind auth_openid
                  auth_pubtkt auth_radius auth_tkt authn_sasl authn_webid
                  authn_yubikey authnz_external authz_unixgroup axis2c bw dacs
                  defensible dnssd encoding evasive fcgid fcgid_dbg geoip gnutls jk
                  ldap_userdir ldap_userdir_dbg lisp log_slow log_sql log_sql_dbi
                  log_sql_mysql log_sql_ssl mapcache mime_xattr mono musicindex neko
                  netcgi_apache nss parser3 passenger php5filter qos removeip rivet
                  rivet_doc rpaf ruid2 ruwsgi ruwsgi_dbg scgi security2 shib2
                  spamhaus suphp svn upload_progress uwsgi uwsgi_dbg vhost_ldap
                  watchcat webauth webauthldap webkdc wsgi_py3 xsendfile modsecurity
                  mpm_itk request_perl sitecontrol_perl svn webauth webkdc
                ),
                found_in_package: ->(name) { "libapache2-mod-#{name.gsub('_', '-')}" }

        #
        # rhel-5
        #
        # shipped in server package
        modules for: { platform_family: 'rhel', platform_version: '5', httpd_version: '2.2' },
                are: %w(
                  actions alias asis auth_basic auth_digest authn_alias authn_anon
                  authn_dbd authn_dbm authn_default authn_file authnz_ldap
                  authz_dbm authz_default authz_groupfile authz_host authz_owner
                  authz_user autoindex cache cern_meta cgi cgid dav dav_fs dbd deflate
                  dir disk_cache dumpio env expires ext_filter file_cache filter
                  headers ident imagemap include info ldap log_config log_forensic
                  logio mem_cache mime mime_magic negotiation proxy proxy proxy_ajp
                  proxy_balancer proxy_connect proxy_ftp proxy_http reqtimeout rewrite
                  setenvif speling status substitute suexec unique_id userdir
                  usertrack version vhost_alias
                ),
                found_in_package: 'httpd'

        # predictable package naming
        modules for: { platform_family: 'rhel', platform_version: '5', httpd_version: '2.2' },
                are: %w(
                  auth_mysql ssl auth_kerb auth_pgsql authz_ldap dav_svn mono nss
                  perl python revocator
                ),
                found_in_package: ->(name) { "mod_#{name}" }

        # outliers
        modules for: { platform_family: 'rhel', platform_version: '5', httpd_version: '2.2' },
                are: %w(authz_svn),
                found_in_package: ->(_name) { 'mod_dav_svn' }

        #
        # rhel-6
        #
        # shipped in server package
        modules for: { platform_family: 'rhel', platform_version: '6', httpd_version: '2.2' },
                are: %w(
                  actions alias asis auth_basic auth_digest authn_alias authn_anon
                  authn_dbd authn_dbm authn_default authn_file authnz_ldap authz_dbm
                  authz_default authz_groupfile authz_host authz_owner authz_user
                  autoindex cache cern_meta cgi cgid dav dav_fs dbd deflate dir
                  disk_cache dumpio env expires ext_filter filter headers ident
                  include info ldap log_config log_forensic logio mime mime_magic
                  negotiation proxy proxy proxy_ajp proxy_balancer proxy_connect
                  proxy_ftp proxy_http proxy_scgi reqtimeout rewrite setenvif speling
                  status substitute suexec unique_id userdir usertrack version
                  vhost_alias
                ),
                found_in_package: 'httpd'

        # predictable package naming
        modules for: { platform_family: 'rhel', platform_version: '6', httpd_version: '2.2' },
                are: %w(
                  auth_kerb auth_mysql auth_pgsql authz_ldap dav_svn dnssd nss
                  perl revocator ssl wsgi
                ),
                found_in_package: ->(name) { "mod_#{name}" }

        # outliers
        modules for: { platform_family: 'rhel', platform_version: '6', httpd_version: '2.2' },
                are: %w(authz_svn),
                found_in_package: ->(_name) { 'mod_dav_svn' }

        #
        # rhel-7
        #
        modules for: { platform_family: 'rhel', platform_version: '7', httpd_version: '2.4' },
                are: %w(
                  access_compat actions alias allowmethods asis auth_basic
                  auth_digest authn_anon authn_core authn_dbd authn_dbm authn_file
                  authn_socache authz_core authz_dbd authz_dbm authz_groupfile
                  authz_host authz_owner authz_user autoindex buffer cache cache_disk
                  cache_socache cgi cgid charset_lite data dav dav_fs dav_lock dbd
                  deflate dialup dir dumpio echo env expires ext_filter file_cache
                  filter headers heartbeat heartmonitor include info
                  lbmethod_bybusyness lbmethod_byrequests lbmethod_bytraffic
                  lbmethod_heartbeat log_config log_debug log_forensic logio lua
                  macro mime mime_magic mpm_event mpm_prefork mpm_worker negotiation
                  proxy proxy_ajp proxy_balancer proxy_connect proxy_express
                  proxy_fcgi proxy_fdpass proxy_ftp proxy_http proxy_scgi
                  proxy_wstunnel ratelimit reflector remoteip reqtimeout request
                  rewrite sed setenvif slotmem_plain slotmem_shm socache_dbm
                  socache_memcache socache_shmcb speling status substitute suexec
                  systemd unique_id unixd userdir usertrack version vhost_alias watchdog
                ),
                found_in_package: 'httpd'

        # predictable package naming
        modules for: { platform_family: 'rhel', platform_version: '7', httpd_version: '2.4' },
                are: %w(
                  auth_kerb dav_svn fcgid ldap nss proxy_html revocator
                  session ssl wsgi
                ),
                found_in_package: ->(name) { "mod_#{name}" }

        # outliers
        modules for: { platform_family: 'rhel', platform_version: '7', httpd_version: '2.4' },
                are: %w(authz_svn dontdothat),
                found_in_package: ->(_name) { 'mod_dav_svn' }

        modules for: { platform_family: 'rhel', platform_version: '7', httpd_version: '2.4' },
                are: %w(authnz_ldap),
                found_in_package: ->(_name) { 'mod_ldap' }

        modules for: { platform_family: 'rhel', platform_version: '7', httpd_version: '2.4' },
                are: %w(xml2enc),
                found_in_package: ->(_name) { 'mod_proxy_html' }

        modules for: { platform_family: 'rhel', platform_version: '7', httpd_version: '2.4' },
                are: %w(rev),
                found_in_package: ->(_name) { 'mod_revocator' }

        modules for: { platform_family: 'rhel', platform_version: '7', httpd_version: '2.4' },
                are: %w(security2),
                found_in_package: ->(_name) { 'mod_security' }

        modules for: { platform_family: 'rhel', platform_version: '7', httpd_version: '2.4' },
                are: %w(auth_form session_cookie session_crypto session_dbd),
                found_in_package: ->(_name) { 'mod_session' }

        #
        # fedora-21
        #
        modules for: { platform_family: 'fedora', platform_version: '21', httpd_version: '2.4' },
                are: %w(
                  access_compat actions alias allowmethods asis auth_basic
                  auth_digest authn_anon authn_core authn_dbd authn_dbm authn_file
                  authn_socache authz_core authz_dbd authz_dbm authz_groupfile
                  authz_host authz_owner authz_user autoindex buffer cache cache_disk
                  cache_socache cgi cgid charset_lite data dav dav_fs dav_lock dbd
                  deflate dialup dir dumpio echo env expires ext_filter file_cache
                  filter headers heartbeat heartmonitor include info
                  lbmethod_bybusyness lbmethod_byrequests lbmethod_bytraffic
                  lbmethod_heartbeat log_config log_debug log_forensic logio lua
                  macro mime mime_magic mpm_event mpm_prefork mpm_worker negotiation
                  proxy proxy_ajp proxy_balancer proxy_connect proxy_express
                  proxy_fcgi proxy_fdpass proxy_ftp proxy_http proxy_scgi
                  proxy_wstunnel ratelimit reflector remoteip reqtimeout request
                  rewrite sed setenvif slotmem_plain slotmem_shm socache_dbm
                  socache_memcache socache_shmcb speling status substitute suexec
                  systemd unique_id unixd userdir usertrack version vhost_alias watchdog
                ),
                found_in_package: 'httpd'

        # predictable package naming
        modules for: { platform_family: 'fedora', platform_version: '21', httpd_version: '2.4' },
                are: %w(
                  auth_kerb dav_svn fcgid ldap nss proxy_html revocator
                  session ssl wsgi
                ),
                found_in_package: ->(name) { "mod_#{name}" }

        # outliers
        modules for: { platform_family: 'fedora', platform_version: '21', httpd_version: '2.4' },
                are: %w(authz_svn dontdothat),
                found_in_package: ->(_name) { 'mod_dav_svn' }

        modules for: { platform_family: 'fedora', platform_version: '21', httpd_version: '2.4' },
                are: %w(authnz_ldap),
                found_in_package: ->(_name) { 'mod_ldap' }

        modules for: { platform_family: 'fedora', platform_version: '21', httpd_version: '2.4' },
                are: %w(xml2enc),
                found_in_package: ->(_name) { 'mod_proxy_html' }

        modules for: { platform_family: 'fedora', platform_version: '21', httpd_version: '2.4' },
                are: %w(rev),
                found_in_package: ->(_name) { 'mod_revocator' }

        modules for: { platform_family: 'fedora', platform_version: '21', httpd_server: '2.4' },
                are: %w(security2),
                found_in_package: ->(_name) { 'mod_security' }

        modules for: { platform_family: 'fedora', platform_version: '21', httpd_version: '2.4' },
                are: %w(auth_form session_cookie session_crypto session_dbd),
                found_in_package: ->(_name) { 'mod_session' }

        # Yeah I don't get it either
        modules for: { platform_family: 'fedora', platform_version: '21', httpd_version: '2.4' },
                are: %w(php),
                found_in_package: ->(_name) { 'php' }

        #
        # amazon-2014.03
        #
        modules for: { platform: 'amazon', platform_version: '2014.03', httpd_version: '2.2' },
                are: %w(
                  actions alias asis auth_basic auth_digest authn_alias authn_anon
                  authn_dbd authn_dbm authn_default authn_file authnz_ldap authz_dbm
                  authz_default authz_groupfile authz_host authz_owner authz_user
                  autoindex cache cern_meta cgi cgid dav dav_fs dbd deflate dir
                  disk_cache dumpio env expires ext_filter file_cache filter headers
                  ident include info ldap log_config log_forensic logio mime
                  mime_magic negotiation proxy proxy proxy_ajp proxy_balancer
                  proxy_connect proxy_ftp proxy_http proxy_scgi reqtimeout rewrite
                  setenvif speling status substitute suexec unique_id userdir
                  usertrack version vhost_alias
                ),
                found_in_package: 'httpd'

        modules for: { platform: 'amazon', platform_version: '2014.03', httpd_version: '2.2' },
                are: %w(
                  perl-devel auth_kerb auth_mysql auth_pgsql
                  authz_ldap dav_svn fcgid geoip nss perl proxy_html python security
                  ssl wsgi
                ),
                found_in_package: ->(name) { "mod_#{name}" }

        modules for: { platform_family: 'amazon', platform_version: '2014.03', httpd_version: '2.2' },
                are: %w(authz_svn),
                found_in_package: ->(_name) { 'mod_dav_svn' }

        modules for: { platform: 'amazon', platform_version: '2014.03', httpd_version: '2.4' },
                are: %w(
                  access_compat actions alias allowmethods asis auth_basic
                  auth_digest authn_anon authn_core authn_dbd authn_dbm authn_file
                  authn_socache authz_core authz_dbd authz_dbm authz_groupfile
                  authz_host authz_owner authz_user autoindex buffer cache cache_disk
                  cache_socache cgi cgid charset_lite data dav dav_fs dav_lock dbd
                  deflate dialup dir dumpio echo env expires ext_filter file_cache
                  filter headers heartbeat heartmonitor include info
                  lbmethod_bybusyness lbmethod_byrequests lbmethod_bytraffic
                  lbmethod_heartbeat log_config log_debug log_forensic logio lua
                  macro mime mime_magic mpm_event mpm_prefork mpm_worker negotiation
                  proxy proxy_ajp proxy_balancer proxy_connect proxy_express
                  proxy_fcgi proxy_fdpass proxy_ftp proxy_http proxy_scgi
                  proxy_wstunnel ratelimit reflector remoteip reqtimeout request
                  rewrite sed setenvif slotmem_plain slotmem_shm socache_dbm
                  socache_memcache socache_shmcb speling status substitute suexec
                  unique_id unixd userdir usertrack version vhost_alias watchdog
                ),
                found_in_package: 'httpd24'

        modules for: { platform: 'amazon', platform_version: '2014.03', httpd_version: '2.4' },
                are: %w(
                  auth_kerb fcgid geoip ldap nss perl proxy_html security session
                  ssl wsgi wsgi_py27
                ),
                found_in_package: ->(name) { "mod24_#{name}" }

        modules for: { platform_family: 'amazon', platform_version: '2014.03', httpd_version: '2.4' },
                are: %w(authz_svn dontdothat),
                found_in_package: ->(_name) { 'mod_dav_svn' }

        modules for: { platform_family: 'amazon', platform_version: '2014.03', httpd_version: '2.4' },
                are: %w(authnz_ldap),
                found_in_package: ->(_name) { 'mod_ldap' }

        modules for: { platform_family: 'amazon', platform_version: '2014.03', httpd_version: '2.4' },
                are: %w(xml2enc),
                found_in_package: ->(_name) { 'mod_proxy_html' }

        modules for: { platform_family: 'amazon', platform_version: '2014.03', httpd_version: '2.4' },
                are: %w(rev),
                found_in_package: ->(_name) { 'mod_revocator' }

        modules for: { platform_family: 'amazon', platform_version: '2014.03', httpd_version: '2.4' },
                are: %w(auth_form session_cookie session_crypto session_dbd),
                found_in_package: ->(_name) { 'mod_session' }
      end
    end
  end
end
