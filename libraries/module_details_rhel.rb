require_relative 'after_installing_dsl'

module Httpd
  module Module
    module Helpers
      def find_details(module_name, platform_family, _platform_version)
        ModuleDetails.find :module_name => module_name,
                           :platform_family => platform_family,
                           :platform_version => platform_family
      end

      class ModuleDetails
        extend ModuleDetailsDSL
        # rhel-5
        after_installing :packages_for => 'auth_kerb',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/auth_kerb.conf ),
                           :and_load => %w( mod_auth_kerb.so )
                         }

        after_installing :packages_for => 'auth_mysql',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/auth_mysql.conf ),
                           :and_load => %w( mod_auth_mysql.so )
                         }

        after_installing :packages_for => 'auth_psql',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/auth_psql.conf ),
                           :and_load => %w( mod_auth_psql.so )
                         }

        after_installing :packages_for => 'authz_ldap',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/authz_ldap.conf ),
                           :and_load => %w( mod_authz_ldap.so ),
                           :binaries => %w( /usr/bin/cert2ldap /usr/bin/certfind )
                         }

        after_installing :packages_for => 'dav_svn',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/subversion.conf ),
                           :and_load => %w( mod_authz_svn.so mod_dav_svn.so )
                         }

        after_installing :packages_for => 'nss',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/nss.conf ),
                           :and_load => %w( libmodnss.so ),
                           :binaries => %w( /usr/sbin/gencert /usr/sbin/nss_pcache )
                         }

        after_installing :packages_for => 'perl',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/perl.conf ),
                           :and_load => %w( mod_perl.so ),
                           :binaries => %w( /usr/bin/mp2bug )
                         }

        after_installing :packages_for => 'python',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/python.conf ),
                           :and_load => %w( mod_python.so )
                         }

        after_installing :packages_for => 'revocator',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/revocator.conf ),
                           :and_load => %w( mod_rev.so ),
                           :binaries => %w( /usr/bin/crlhelper /usr/bin/ldapget )
                         }

        after_installing :packages_for => 'ssl',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/ssl.conf ),
                           :and_load => %w( mod_ssl.so )
                         }

        # rhel-6
        after_installing :packages_for => 'auth_kerb',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/auth_kerb.conf ),
                           :and_load => %w( mod_auth_kerb.so )
                         }

        after_installing :packages_for => 'auth_mysql',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/auth_mysql.conf ),
                           :and_load => %w( mod_auth_mysql.so )
                         }

        after_installing :packages_for => 'authz_ldap',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/authz_ldap.conf ),
                           :and_load => %w( mod_authz_ldap.so ),
                           :binaries => %w( /usr/bin/cert2ldap /usr/bin/certfind )
                         }

        after_installing :packages_for => 'dav_svn',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/subversion.conf ),
                           :and_load => %w( mod_authz_svn.so mod_dav_svn.so )
                         }

        after_installing :packages_for => 'dnssd',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/mod_dnssd.conf ),
                           :and_load => %w( mod_dnssd.so )
                         }

        after_installing :packages_for => 'nss',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/nss.conf ),
                           :and_load => %w( libmodnss.so ),
                           :binaries => %w( /usr/sbin/gencert /usr/sbin/nss_pcache )
                         }

        after_installing :packages_for => 'perl',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/perl.conf ),
                           :and_load => %w( mod_perl.so ),
                           :binaries => %w( /usr/bin/mp2bug )
                         }

        after_installing :packages_for => 'revocator',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/revocator.conf ),
                           :and_load => %w( mod_rev.so ),
                           :binaries => %w( /usr/bin/crlhelper /usr/bin/ldapget )
                         }

        after_installing :packages_for => 'ssl',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/ssl.conf ),
                           :and_load => %w( mod_ssl.so )
                         }

        after_installing :packages_for => 'wsgi',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/wsgi.conf ),
                           :and_load => %w( mod_wsgi.so )
                         }

        # rhel-7
        after_installing :packages_for => 'auth_kerb',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/10-auth_kerb.conf ),
                           :and_load => %w( mod_auth_kerb.so )
                         }

        after_installing :packages_for => 'dav_svn',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/10-subversion.conf ),
                           :and_load => %w( mod_authz_svn.so mod_dav_svn.so mod_dontdothat.so )
                         }

        after_installing :packages_for => 'fcgid',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/fcgid.conf
                             /etc/httpd/conf.modules.d/10-fcgid.conf
                           ),
                           :and_load => %w( mod_fcgid.so )
                         }

        after_installing :packages_for => 'ldap',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/01-ldap.conf ),
                           :and_load => %w( mod_authnz_ldap.so mod_ldap.so )
                         }

        after_installing :packages_for => 'nss',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/nss.conf
                             /etc/httpd/conf.modules.d/10-nss.conf
                           ),
                           :and_load => %w( libmodnss.so ),
                           :binaries => %w( /usr/libexec/nss_pcache /usr/sbin/gencert /usr/sbin/nss_pcache )
                         }

        after_installing :packages_for => 'proxy_html',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/00-proxyhtml.conf ),
                           :and_load => %w( mod_proxy_html.so mod_xml2enc.so )
                         }

        after_installing :packages_for => 'revocator',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/revocator.conf
                             /etc/httpd/conf.modules.d/11-revocator.conf
                           ),
                           :and_load => %w( mod_rev.so ),
                           :binaries => %w(
                             /usr/bin/crlhelper /usr/bin/ldapget
                             /usr/libexec/crlhelper /usr/sbin/ldapget
                           )
                         }

        after_installing :packages_for => 'security',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/mod_security.conf
                             /etc/httpd/conf.modules.d/10-mod_security.conf
                           ),
                           :and_load => %w( mod_security2.so )
                         }

        after_installing :packages_for => 'session',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/01-session.conf ),
                           :and_load => %w(
                             mod_auth_form.so mod_session.so
                             mod_session_cookie.so mod_session_crypto.so
                             mod_session_dbd.so
                           )
                         }

        after_installing :packages_for => 'ssl',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/ssl.conf
                             /etc/httpd/conf.modules.d/00-ssl.conf
                           ),
                           :and_load => %w( mod_ssl.so )
                         }

        after_installing :packages_for => 'wsgi',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/10-wsgi.conf ),
                           :and_load => %w( mod_wsgi.so )
                         }
      end
    end
  end
end
