require_relative '../../libraries/info_module_packages'

describe 'looking up module package name' do
  before do
    extend HttpdCookbook::Helpers
  end

  context 'for apache 2.4 on ubuntu 14.04' do
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

    debian_2_4_core.each do |m|
      it 'returns the proper package name' do
        expect(
          package_name_for_module(m, '2.4', 'ubuntu', 'debian', '14.04')
          ).to eq('apache2')
      end
    end

    debian_2_4_other.each do |m|
      it 'returns the proper package name' do
        expect(
          package_name_for_module(m, '2.4', 'ubuntu', 'debian', '14.04')
          ).to eq("libapache2-mod-#{m.gsub('_', '-')}")
      end
    end
  end
end
