require_relative '../../libraries/info_module_packages'

describe 'looking up module package name' do
  before do
    extend HttpdCookbook::Helpers
  end

  context 'for apache 2.2 on amazon' do
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

    amazon_2_2_other = %w(
      perl-devel auth_kerb auth_mysql auth_pgsql authz_ldap dav_svn
      fcgid geoip nss perl proxy_html python security ssl wsgi
    )

    amazon_2_2_core.each do |m|
      it 'returns the proper package name' do
        expect(
          package_name_for_module(m, '2.2', 'amazon', 'rhel', '2014.03')
        ).to eq('httpd')
      end
    end

    amazon_2_2_other.each do |m|
      it 'returns the proper package name' do
        expect(
          package_name_for_module(m, '2.2', 'amazon', 'rhel', '2014.03')
        ).to eq("mod_#{m}")
      end
    end
  end
end
