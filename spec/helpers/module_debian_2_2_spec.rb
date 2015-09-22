require_relative '../../libraries/info_module_packages'

describe 'looking up module package name' do
  before do
    extend HttpdCookbook::Helpers
  end

  context 'for apache 2.2 on debian 7, 10.04, and 12.04' do
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

    debian_2_2_core.each do |m|
      it 'returns the proper package name' do
        expect(
          package_name_for_module(m, '2.2', 'debian', 'debian', '7.2')
        ).to eq('apache2')
        expect(
          package_name_for_module(m, '2.2', 'debian', 'debian', '10.04')
        ).to eq('apache2')
        expect(
          package_name_for_module(m, '2.2', 'debian', 'debian', '12.04')
        ).to eq('apache2')
      end
    end

    debian_2_2_other.each do |m|
      it 'returns the proper package name' do
        expect(
          package_name_for_module(m, '2.2', 'debian', 'debian', '7.2')
        ).to eq("libapache2-mod-#{m.tr('_', '-')}")
      end
    end
  end
end
