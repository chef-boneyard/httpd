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
                         :auth_mysql => {
                           :delete_on_package_repair => %w( auth_mysql.conf ),
                           :module_filenames => %w( mod_auth_mysql )
                         },
                       }

        # rhel-7
        module_details :for => { :platform_family => 'rhel', :platform_version => '7', :httpd_version => '2.4' },
                       :are => {
                         :auth_kerb => {
                           :delete_files => %w( 10-auth_kerb.conf )
                         },
                         :auth_dav_svn => {
                           :delete_files => %w( 10-subversion.conf ),
                           :create_configs => %w( 10-auth_kerb.conf ),
                           :module_filenames => %w(
                             mod_authz_svn.so
                             mod_dav_svn.so
                             mod_dontdothat.so
                           )
                         },
                         :ldap => {
                           :delete_files => %w( 01-ldap.conf ),
                           :create_configs => %w( 01-ldap.conf ),
                           :module_filenames => %w(
                             mod_authnz_ldap.so
                             mod_ldap.so
                           )
                         }

                       }

        module_details :for => { :platform_family => 'rhel', :platform_version => '7', :httpd_version => '2.2' },
                       :are => {
                         :auth_kerb => {
                           :delete_files => %w( 10-auth_kerb.conf )
                         },
                         :auth_dav_svn => {
                           :delete_files => %w( 10-subversion.conf ),
                           :create_configs => %w( 10-auth_kerb.conf ),
                           :module_filenames => %w(
                             mod_authz_svn.so
                             mod_dav_svn.so
                             mod_dontdothat.so
                           )
                         },
                         :ldap => {
                           :delete_files => %w( 01-ldap.conf ),
                           :create_configs => %w( 01-ldap.conf ),
                           :module_filenames => %w(
                             mod_authnz_ldap.so
                             mod_ldap.so
                           )
                         }

                       }
      end
    end
  end
end
