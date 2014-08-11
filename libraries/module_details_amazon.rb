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

      def delete_files_for_package(name, httpd_version)
        ModuleDetails.find_deletes(
          :package => name,
          :httpd_version => httpd_version,
          :platform => node['platform'],
          :platform_family => node['platform_family'],
          :platform_version => keyname_for(
            node['platform'],
            node['platform_family'],
            node['platform_version']
            )
          )
      end

      class ModuleDetails
        extend ModuleDetailsDSL
        # 2.2
        after_installing :package => 'httpd',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/README /etc/httpd/conf.d/welcome.conf)
                         }

        after_installing :package => 'mod_auth_kerb',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/auth_kerb.conf )
                         }

        after_installing :package => 'mod_auth_mysql',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/auth_mysql.conf )
                         }

        after_installing :package => 'mod_authz_ldap',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/authz_ldap.conf )
                         }

        after_installing :package => 'mod_geoip',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/geoip.conf )
                         }

        after_installing :package => 'mod_fcgid',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %( /etc/httpd/conf.d/fcgid.conf )
                         }

        after_installing :package => 'mod_dav_svn',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/subversion.conf )
                         }

        after_installing :package => 'mod_dnssd',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/mod_dnssd.conf )
                         }

        after_installing :package => 'mod_nss',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/nss.conf )
                         }

        after_installing :package => 'mod_perl',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/perl.conf )
                         }

        after_installing :package => 'mod_revocator',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/revocator.conf )
                         }

        after_installing :package => 'mod_ssl',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/ssl.conf )
                         }

        after_installing :package => 'mod_wsgi',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.2', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.d/wsgi.conf )
                         }

        # 2.4
        after_installing :package => 'httpd',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.4', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/autoindex.conf
                             /etc/httpd/conf.d/README
                             /etc/httpd/conf.d/userdir.conf
                             /etc/httpd/conf.d/welcome.conf
                             /etc/httpd/conf.modules.d/00-base.conf
                             /etc/httpd/conf.modules.d/00-dav.conf
                             /etc/httpd/conf.modules.d/00-lua.conf
                             /etc/httpd/conf.modules.d/00-mpm.conf
                             /etc/httpd/conf.modules.d/00-proxy.conf
                             /etc/httpd/conf.modules.d/00-systemd.conf
                             /etc/httpd/conf.modules.d/01-cgi.conf
                           )
                         }

        after_installing :package => 'mod_auth_kerb',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.4', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/10-auth_kerb.conf )
                         }

        after_installing :package => 'mod_fcgid',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.4', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/fcgid.conf
                             /etc/httpd/conf.modules.d/10-fcgid.conf
                           )
                         }

        after_installing :package => 'mod_geoip',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.4', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/geoip.conf
                             /etc/httpd/conf.modules.d/10-geoip.conf
                           )
                         }

        after_installing :package => 'mod_ldap',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.4', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/01-ldap.conf )
                         }

        after_installing :package => 'mod_nss',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.4', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/nss.conf
                             /etc/httpd/conf.modules.d/10-nss.conf
                           )
                         }

        after_installing :package => 'mod_proxy_html',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.4', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/00-proxyhtml.conf )
                         }

        after_installing :package => 'mod_security',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.4', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/mod_security.conf
                             /etc/httpd/conf.modules.d/10-mod_security.conf
                           )
                         }

        after_installing :package => 'mod_session',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.4', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/01-session.conf )
                         }

        after_installing :package => 'mod_ssl',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.4', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w(
                             /etc/httpd/conf.d/ssl.conf
                             /etc/httpd/conf.modules.d/00-ssl.conf
                           )
                         }

        after_installing :package => 'mod_wsgi',
                         :on => { :platform_family => 'amazon', :httpd_version => '2.4', :platform_version => '2014.03'  },
                         :chef_should => {
                           :delete_files => %w( /etc/httpd/conf.modules.d/10-wsgi.conf )
                         }
      end
    end
  end
end
