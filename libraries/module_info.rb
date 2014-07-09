module Opscode
  module Httpd
    module Module
      module Helpers
        class ModuleInfo
          def self.debian_2_2_core
            debian_2_2_core = %w(
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
            debian_2_2_other = %w(
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
            debian_2_4_core = %w(
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
            debian_2_4_other = %w(
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
            )
          end

          def self.rhel_5_2_2_core
            rhel_5_2_2_core = %w(
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

          def self.rhel_5_2_2_other
            rhel_5_2_2_other = %w(
              auth_mysql ssl auth_kerb auth_pgsql authz_ldap dav_svn mono nss
              perl perl-devel perl-devel python revocator
            )
          end

          def self.rhel_6_2_2_core
            rhel_6_2_2_core = %w(
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

          def self.rhel_6_2_2_other
            rhel_6_2_2_other = %w(
              perl-devel perl-devel auth_kerb auth_mysql auth_pgsql authz_ldap
              dav_svn dnssd nss perl revocator revocator ssl wsgi
            )
          end

          def self.amazon_2_2_core
            amazon_2_2_core = %w(
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

          def self.amazon_2_2_other
            amazon_2_2_other = %w(
              perl-devel security_crs-extras auth_kerb auth_mysql auth_pgsql
              authz_ldap dav_svn fcgid geoip nss perl proxy_html python security
              security_crs ssl wsgi
            )
          end

          def self.amazon_2_4_core
            amazon_2_4_core = %w(
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

          def self.amazon_2_4_other
            amazon_2_4_other = %w(
              auth_kerb fcgid geoip ldap nss perl proxy_html security session
              ssl wsgi wsgi_py27
            )
          end

          def self.fedora_20_2_4_core
            fedora_20_2_4_core = %w(
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

          def self.fedora_20_2_4_other
            fedora_20_2_4_other = %w(
              annodex auth_cas auth_kerb auth_mellon auth_ntlm_winbind
              authnz_external authnz_pam auth_token auth_xradius autoindex_mb
              bw cluster cluster-java cluster-javadoc dav_svn dnssd evasive
              fcgid flvx form form form-devel form-devel geoip gnutls
              intercept_form_submit ldap limitipconn log_post lookup_identity
              mirrorbrain nss passenger perl perl perl-devel perl-devel
              proxy_html proxy_uwsgi qos revocator revocator security
              security_crs security_crs-extras selinux session speedycgi ssl
              suphp wsgi wso2-axis2 xsendfile
            )
          end
        end

        class MethodInfo
          def self.method_info
            @method_info ||= {
              'debian' => {
                '7' => { '2.2' => 'debian_2_2' },
                'jessie' => { '2.4' => 'debian_2_4' },
                '10.04' => { '2.2' => 'debian_2_2' },
                '12.04' => { '2.2' => 'debian_2_2' },
                '14.04' => { '2.4' => 'debian_2_4' }
              },
              'rhel' => {
                '5' => { '2.2' => 'rhel_5_2_2' },
                '6' => { '2.2' => 'rhel_6_2_2' },
                '2014.03' => {
                  '2.2' => 'amazon_2_2',
                  '2.4' => 'amazon_2_4'
                }
              },
              'fedora' => {
                '20' => { '2.4' => 'fedora_20_2_4' }
              }
            }
          end
        end

        def keyname_for(platform, platform_family, platform_version)
          case
          when platform_family == 'rhel'
            platform == 'amazon' ? platform_version : platform_version.to_i.to_s
          when platform_family == 'suse'
            platform_version
          when platform_family == 'fedora'
            platform_version
          when platform_family == 'debian'
            if platform == 'ubuntu'
              platform_version
            elsif platform_version =~ /sid$/
              platform_version
            else
              platform_version.to_i.to_s
            end
          when platform_family == 'smartos'
            platform_version
          when platform_family == 'omnios'
            platform_version
          when platform_family == 'freebsd'
            platform_version.to_i.to_s
          end
        rescue NoMethodError
          nil
        end

        def package_name_for_module(name, httpd_version, platform, platform_family, platform_version)
          # if platform == 'fedora'
          #   require 'pry' ; binding.pry
          # end

          keyname = keyname_for(platform, platform_family, platform_version)
          method_name = MethodInfo.method_info[platform_family][keyname][httpd_version]

          case platform_family
          when 'debian'
            if ModuleInfo.send("#{method_name}_core").include? name
              'apache2'
            elsif ModuleInfo.send("#{method_name}_other").include? name
              "libapache2-mod-#{name.gsub('_', '-')}"
            else
              nil
            end

          when 'rhel'
            if ModuleInfo.send("#{method_name}_core").include? name
              'httpd'
            elsif ModuleInfo.send("#{method_name}_other").include? name
              "mod_#{name}"
            else
              nil
            end

          when 'fedora'
            if ModuleInfo.send("#{method_name}_core").include? name
              'httpd'
            elsif ModuleInfo.send("#{method_name}_other").include? name
              "mod_#{name}"
            else
              nil
            end
          end
        end
      end
    end
  end
end
