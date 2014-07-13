require_relative '../../libraries/module_info.rb'

describe 'looking up module package name' do
  before do
    extend Httpd::Module::Helpers
  end

  context 'for apache 2.4 on fedora 20' do
    fedora_20_2_2_core = %w(
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

    fedora_20_2_2_other = %w(
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

    fedora_20_2_2_core.each do |m|
      it 'returns the proper package name' do
        expect(
          package_name_for_module(m, '2.4', 'fedora', 'fedora', '20')
          ).to eq('httpd')
      end
    end

    fedora_20_2_2_other.each do |m|
      it 'returns the proper package name' do
        expect(
          package_name_for_module(m, '2.4', 'fedora', 'fedora', '20')
          ).to eq("mod_#{m}")
      end
    end
  end
end
