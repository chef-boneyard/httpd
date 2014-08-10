require_relative 'module_details_dsl'

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

      def delete_files_for_module(name, httpd_version, platform, platform_family, platform_version)
        ModuleDetails.find_deletes(
          :module => name,
          :httpd_version => httpd_version,
          :platform => platform,
          :platform_family => platform_family,
          :platform_version => keyname_for(platform, platform_family, platform_version)
          )
      end

      class ModuleDetails
        extend ModuleDetailsDSL
        # rhel-5
        after_installing :module => 'auth_kerb',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/auth_kerb.conf )
                         }

        after_installing :module => 'auth_mysql',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/auth_mysql.conf )
                         }

        after_installing :module => 'auth_psql',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/auth_psql.conf )
                         }

        after_installing :module => 'authz_ldap',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/authz_ldap.conf )
                         }

        after_installing :module => 'dav_svn',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/subversion.conf )
                         }

        after_installing :module => 'nss',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/nss.conf )
                         }

        after_installing :module => 'perl',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/perl.conf )
                         }

        after_installing :module => 'python',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/python.conf )
                         }

        after_installing :module => 'revocator',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/revocator.conf )
                         }

        after_installing :module => 'ssl',
                         :on => { :platform_family => 'rhel', :platform_version => '5'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/ssl.conf )
                         }

        # rhel-6
        after_installing :module => 'auth_kerb',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/auth_kerb.conf )
                         }

        after_installing :module => 'auth_mysql',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/auth_mysql.conf )
                         }

        after_installing :module => 'authz_ldap',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/authz_ldap.conf )
                         }

        after_installing :module => 'dav_svn',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/subversion.conf )
                         }

        after_installing :module => 'dnssd',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/mod_dnssd.conf )
                         }

        after_installing :module => 'nss',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/nss.conf ),
                         }

        after_installing :module => 'perl',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/perl.conf )
                         }

        after_installing :module => 'revocator',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/revocator.conf )
                         }

        after_installing :module => 'ssl',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/ssl.conf )
                         }

        after_installing :module => 'wsgi',
                         :on => { :platform_family => 'rhel', :platform_version => '6'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/wsgi.conf ),
                         }

        # rhel-7
        after_installing :module => 'auth_kerb',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/10-auth_kerb.conf )
                         }

        after_installing :module => 'dav_svn',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/10-subversion.conf )
                         }

        after_installing :module => 'fcgid',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/fcgid.conf
                             /etc/httpd/conf.modules.d/10-fcgid.conf
                           )
                         }

        after_installing :module => 'ldap',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/01-ldap.conf )
                         }

        after_installing :module => 'nss',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/nss.conf
                             /etc/httpd/conf.modules.d/10-nss.conf
                           )
                         }

        after_installing :module => 'proxy_html',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/00-proxyhtml.conf )
                         }

        after_installing :module => 'revocator',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/revocator.conf
                             /etc/httpd/conf.modules.d/11-revocator.conf
                           )
                         }

        after_installing :module => 'security',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/mod_security.conf
                             /etc/httpd/conf.modules.d/10-mod_security.conf
                           )
                         }

        after_installing :module => 'session',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/01-session.conf )
                         }

        after_installing :module => 'ssl',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/ssl.conf
                             /etc/httpd/conf.modules.d/00-ssl.conf
                           )
                         }

        after_installing :module => 'wsgi',
                         :on => { :platform_family => 'rhel', :platform_version => '7'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/10-wsgi.conf )
                         }
      end
    end
  end
end
