module Opscode
  module Httpd
    module Module
      module Helpers
        class ModuleInfo
          def self.debian_2_2_core
            @debian_2_2_core = %w(
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
            )
          end

          def self.debian_2_2_other
            @debian_2_2_other = %w(
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
            )
          end

          def self.debian_2_4_core
            @debian_2_4_core = %w(
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
            )
          end

          def self.debian_2_4_other
            @debian_2_4_other = %w(
              apparmor auth_mysql auth_pgsql auth_plain macro perl2 perl2_dev
              perl2_doc php5 python python_doc wsgi reload_perl fastcgi
              authcassimple_perl authcookie_perl authenntlm_perl apreq2 auth_cas
              auth_kerb auth_mellon auth_memcookie auth_ntlm_winbind auth_openid
              auth_pubtkt auth_radius auth_tkt authn_sasl authn_webid
              authn_yubikey authnz_external authz_unixgroup axis2c bw dacs
              defensible dnssd encoding evasive fcgid fcgid_dbg geoip gnutls jk
              ldap_userdir ldap_userdir_dbg lisp log_slow log_sql log_sql_dbi
              log_sql_mysql log_sql_ssl mapcache mime_xattr mono musicindex neko
              netcgi_apache nss parser3 passenger php5filter proxy_html
              proxy_msrpc proxy_uwsgi proxy_uwsgi_dbg qos removeip rivet
              rivet_doc rpaf ruid2 ruwsgi ruwsgi_dbg scgi security2 shib2
              spamhaus suphp svn upload_progress uwsgi uwsgi_dbg vhost_ldap
              watchcat webauth webauthldap webkdc wsgi_py3 xsendfile modsecurity
              mpm_itk request_perl sitecontrol_perl svn webauth webkdc
            )
          end

          def self.rhel_5_2_2_core
            @rhel_5_2_2_core = %w(
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
            )
          end

          def self.rhel_6_2_2_core
            @rhel_6_2_2_core = %w(
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
            )
          end

          def self.amazon_2_2_core
            @amazon_2_2_core = %w(
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
            )
          end

          def self.amazon_2_4_core
            @amazon_2_2_core = %w(
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
            )
          end

          def self.fedora_20_2_4_core
            @fedora_20_2_4_core = %w(
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
            )
          end

          
          def package_name_for_module(name, _httpd_version, _platform, _platform_version)
            if ModuleInfo.debian_2_2_core.include? name
              'apache2'
            elsif ModuleInfo.debian_2_2_other.include? name
              "libapache2-mod-#{name.gsub('_', '-')}"
            else
              nil
            end
          end
        end
      end
    end
  end
end
