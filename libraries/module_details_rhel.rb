require_relative 'module_details_dsl'

module Httpd
  module Module
    module Helpers
      def find_details(module_name, platform_family, _platform_version)
        ModuleDetails.find :module_name => module_name,
        :platform_family => platform_family,
        :platform_version => platform_family
      end

      class ModuleDetails
        # rhel-5
        module_details :for => { :platform_family => 'rhel', :platform_version => '5'  },
        :are => {
          'auth_kerb' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/auth_kerb.conf ),
            :module_filenames => %w( mod_auth_kerb.so )
          },
          'auth_mysql' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/auth_mysql.conf ),
            :module_filenames => %w( mod_auth_mysql.so )
          },
          'auth_psql' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/auth_psql.conf ),
            :module_filenames => %w( mod_auth_psql.so )
          },
          'authz_ldap' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/authz_ldap.conf ),
            :module_filenames => %w( mod_authz_ldap.so ),
            :binaries => %w( /usr/bin/cert2ldap /usr/bin/certfind )
          },
          'dav_svn' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/subversion.conf ),
            :module_filenames => %w( mod_authz_svn.so mod_dav_svn.so )
          },
          'nss' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/nss.conf ),
            :module_filenames => %w( libmodnss.so ),
            :binaries => %w( /usr/sbin/gencert /usr/sbin/nss_pcache )
          },
          'perl' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/perl.conf ),
            :module_filenames => %w( mod_perl.so ),
            :binaries => %w( /usr/bin/mp2bug )
          },
          'python' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/python.conf ),
            :module_filenames => %w( mod_python.so )
          },
          'revocator' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/revocator.conf ),
            :module_filenames => %w( mod_rev.so ),
            :module_filenames => %w( /usr/bin/crlhelper /usr/bin/ldapget )
          },
          'ssl' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/ssl.conf ),
            :module_filenames => %w( mod_ssl.so )
          }
        }
        
        # rhel-6
        module_details :for => { :platform_family => 'rhel', :platform_version => '6'  },
        :are => {
          'auth_kerb' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/auth_kerb.conf ),
            :module_filenames => %w( mod_auth_kerb.so )
          },
          'auth_mysql' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/auth_mysql.conf ),
            :module_filenames => %w( mod_auth_mysql.so )
          },
          'authz_ldap' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/authz_ldap.conf ),
            :module_filenames => %w( mod_authz_ldap.so ),
            :binaries => %w( /usr/bin/cert2ldap /usr/bin/certfind )
          },
          'dav_svn' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/subversion.conf ),
            :module_filenames => %w( mod_authz_svn.so mod_dav_svn.so )
          },
          'dnssd' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/mod_dnssd.conf ),
            :module_filenames => %w( mod_dnssd.so )
          },
          'nss' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/nss.conf ),
            :module_filenames => %w( libmodnss.so ),
            :binaries => %w( /usr/sbin/gencert /usr/sbin/nss_pcache )
          },
          'perl' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/perl.conf ),
            :module_filenames => %w( mod_perl.so ),
            :binaries => %w( /usr/bin/mp2bug )
          },
          'revocator' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/revocator.conf ),
            :module_filenames => %w( mod_rev.so ),
            :binaries => %w( /usr/bin/crlhelper /usr/bin/ldapget )
          },
          'ssl' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/ssl.conf ),
            :module_filenames => %w( mod_ssl.so )
          },
          'wsgi' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.d/wsgi.conf ),
            :module_filenames => %w( mod_wsgi.so )
          }
        }

        module_details :for => { :platform_family => 'rhel', :platform_version => '7'  },
        :are => {
          'auth_kerb' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.modules.d/10-auth_kerb.conf ),
            :module_filenames => %w( mod_auth_kerb.so )
          },
          'dav_svn' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.modules.d/10-subversion.conf ),
            :module_filenames => %w( mod_authz_svn.so mod_dav_svn.so mod_dontdothat.so )
          },
          'fcgid' => {
            :delete_on_package_repair => %w(
              /etc/httpd/conf.d/fcgid.conf
              /etc/httpd/conf.modules.d/10-fcgid.conf
            ),
            :module_filenames => %w( mod_fcgid.so )
          },
          'ldap' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.modules.d/01-ldap.conf ),
            :module_filenames => %w( mod_authnz_ldap.so mod_ldap.so )
          },
          'nss' => {
            :delete_on_package_repair => %w(
              /etc/httpd/conf.d/nss.conf
              /etc/httpd/conf.modules.d/10-nss.conf
            ),
            :module_filenames => %w( libmodnss.so ),
            :binaries => %w( /usr/libexec/nss_pcache /usr/sbin/gencert /usr/sbin/nss_pcache )
          },
          'proxy_html' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.modules.d/00-proxyhtml.conf ),
            :module_filenames => %w( mod_proxy_html.so mod_xml2enc.so )
          },
          'revocator' => {
            :delete_on_package_repair => %w(
              /etc/httpd/conf.d/revocator.conf
              /etc/httpd/conf.modules.d/11-revocator.conf
            ),
            :module_filenames => %w( mod_rev.so ),
            :binaries => %w(
               /usr/bin/crlhelper /usr/bin/ldapget
               /usr/libexec/crlhelper /usr/sbin/ldapget
            )
          },
          'security' => {
            :delete_on_package_repair => %w(
              /etc/httpd/conf.d/mod_security.conf
              /etc/httpd/conf.modules.d/10-mod_security.conf
            ),
            :module_filenames => %w( mod_security2.so )
          },
          'session' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.modules.d/01-session.conf ),
            :module_filenames => %w(
              mod_auth_form.so mod_session.so
              mod_session_cookie.so mod_session_crypto.so
              mod_session_dbd.so
            )
          },
          'session' => {
            :delete_on_package_repair => %w(
              /etc/httpd/conf.d/ssl.conf
              /etc/httpd/conf.modules.d/00-ssl.conf
            ),
            :module_filenames => %w( mod_ssl.so )
          },
          'wsgi' => {
            :delete_on_package_repair => %w( /etc/httpd/conf.modules.d/10-wsgi.conf ),
            :module_filenames => %w( mod_wsgi.so )
          }
        }
      end
    end
  end
end
