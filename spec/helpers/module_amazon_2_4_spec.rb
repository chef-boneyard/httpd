require_relative '../../libraries/info_module_packages'

describe 'looking up module package name' do
  before do
    extend HttpdCookbook::Helpers
  end

  context 'for apache 2.4 on amazon' do
    amazon_2_4_core = %w(
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
      unique_id unixd userdir usertrack version vhost_alias watchdog
    )

    amazon_2_4_other = %w(
      auth_kerb fcgid geoip ldap nss perl proxy_html security session
      ssl wsgi wsgi_py27
    )

    amazon_2_4_core.each do |m|
      it 'returns the proper package name' do
        expect(
          package_name_for_module(m, '2.4', 'amazon', 'rhel', '2014.03')
        ).to eq('httpd24')
      end
    end

    amazon_2_4_other.each do |m|
      it 'returns the proper package name' do
        expect(
          package_name_for_module(m, '2.4', 'amazon', 'rhel', '2014.03')
        ).to eq("mod24_#{m}")
      end
    end
  end
end
