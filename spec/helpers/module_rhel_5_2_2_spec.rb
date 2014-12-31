require_relative '../../libraries/info_module_packages'

describe 'looking up module package name' do
  before do
    extend HttpdCookbook::Helpers
  end

  context 'for apache 2.2 on rhel 5' do
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

    rhel_5_2_2_other = %w(
      auth_mysql ssl auth_kerb auth_pgsql authz_ldap dav_svn mono nss
      perl python revocator
    )

    rhel_5_2_2_core.each do |m|
      it 'returns the proper package name' do
        expect(
          package_name_for_module(m, '2.2', 'centos', 'rhel', '5.8')
          ).to eq('httpd')
      end
    end

    rhel_5_2_2_other.each do |m|
      it 'returns the proper package name' do
        expect(
          package_name_for_module(m, '2.2', 'centos', 'rhel', '5.8')
          ).to eq("mod_#{m}")
      end
    end
  end
end
