require_relative '../../libraries/module_details_rhel.rb'
require_relative '../../libraries/module_details_dsl.rb'

describe 'looking up module package name' do
  before do
    extend Httpd::Module::Helpers
  end

  context 'for apache 2.2 on rhel-5' do
    # auth_kerb for 2.2 on rhel-5
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('auth_kerb', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['/etc/httpd/conf.d/auth_kerb.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('auth_kerb', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['mod_auth_kerb.so'])
    end

    # auth_mysql for 2.2 on rhel-5
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('auth_mysql', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['/etc/httpd/conf.d/auth_mysql.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('auth_mysql', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['mod_auth_mysql.so'])
    end

    # auth_psql for 2.2 on rhel-5
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('auth_psql', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['/etc/httpd/conf.d/auth_psql.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('auth_psql', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['mod_auth_psql.so'])
    end

    # authz_ldap for 2.2 on rhel-5
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('authz_ldap', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['/etc/httpd/conf.d/authz_ldap.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('authz_ldap', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['mod_authz_ldap.so'])
    end

    # dav_svn for 2.2 on rhel-5
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('dav_svn', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['/etc/httpd/conf.d/subversion.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('dav_svn', '2.2', 'centos', 'rhel', '5.5')
        ).to eq([
          'mod_authz_svn.so',
          'mod_dav_svn.so'
        ])
    end

    # nss for 2.2 on rhel-5
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('nss', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['/etc/httpd/conf.d/nss.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('nss', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['libmodnss.so'])
    end

    # perl for 2.2 on rhel-5
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('perl', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['/etc/httpd/conf.d/perl.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('perl', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['mod_perl.so'])
    end

    # python for 2.2 on rhel-5
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('python', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['/etc/httpd/conf.d/python.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('python', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['mod_python.so'])
    end

    # revocator for 2.2 on rhel-5
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('revocator', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['/etc/httpd/conf.d/revocator.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('revocator', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['mod_rev.so'])
    end

    # ssl for 2.2 on rhel-5
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('ssl', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['/etc/httpd/conf.d/ssl.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('ssl', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['mod_ssl.so'])
    end

  end

  context 'for apache 2.2 on rhel-5' do
    # auth_kerb for 2.2 on rhel-6
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('auth_kerb', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['/etc/httpd/conf.d/auth_kerb.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('auth_kerb', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['mod_auth_kerb.so'])
    end

    # auth_mysql for 2.2 on rhel-6
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('auth_mysql', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['/etc/httpd/conf.d/auth_mysql.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('auth_mysql', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['mod_auth_mysql.so'])
    end

    # authz_ldap for 2.2 on rhel-6
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('authz_ldap', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['/etc/httpd/conf.d/authz_ldap.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('authz_ldap', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['mod_authz_ldap.so'])
    end

    # dav_svn for 2.2 on rhel-6
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('dav_svn', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['/etc/httpd/conf.d/subversion.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('dav_svn', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['mod_authz_svn.so', 'mod_dav_svn.so'])
    end

    # dnssd for 2.2 on rhel-6
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('dnssd', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['/etc/httpd/conf.d/mod_dnssd.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('dnssd', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['mod_dnssd.so'])
    end

    # nss for 2.2 on rhel-6
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('nss', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['/etc/httpd/conf.d/nss.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('nss', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['libmodnss.so'])
    end

    # perl for 2.2 on rhel-6
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('perl', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['/etc/httpd/conf.d/perl.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('perl', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['mod_perl.so'])
    end

    # revocator for 2.2 on rhel-6
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('revocator', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['/etc/httpd/conf.d/revocator.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('revocator', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['mod_rev.so'])
    end

    # wsgi for 2.2 on rhel-6
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('wsgi', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['/etc/httpd/conf.d/wsgi.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('wsgi', '2.2', 'centos', 'rhel', '6.4')
        ).to eq(['mod_wsgi.so'])
    end
  end

  context 'for apache 2.4 on rhel-7' do
    # auth_kerb for 2.4 on rhel-7
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('auth_kerb', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['/etc/httpd/conf.modules.d/10-auth_kerb.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('auth_kerb', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['mod_auth_kerb.so'])
    end

    # dav_svn for 2.4 on rhel-7
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('dav_svn', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['/etc/httpd/conf.modules.d/10-subversion.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('dav_svn', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['mod_authz_svn.so', 'mod_dav_svn.so', 'mod_dontdothat.so'])
    end

    # fcgid for 2.4 on rhel-7
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('fcgid', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['/etc/httpd/conf.d/fcgid.conf', '/etc/httpd/conf.modules.d/10-fcgid.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('fcgid', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['mod_fcgid.so'])
    end

    # ldap for 2.4 on rhel-7
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('ldap', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['/etc/httpd/conf.modules.d/01-ldap.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('ldap', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['mod_authnz_ldap.so', 'mod_ldap.so'])
    end

    # nss for 2.4 on rhel-7
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('nss', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['/etc/httpd/conf.d/nss.conf', '/etc/httpd/conf.modules.d/10-nss.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('nss', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['libmodnss.so'])
    end

    # proxy_html for 2.4 on rhel-7
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('proxy_html', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['/etc/httpd/conf.modules.d/00-proxyhtml.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('proxy_html', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['mod_proxy_html.so', 'mod_xml2enc.so'])
    end

    # revocator for 2.4 on rhel-7
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('revocator', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['/etc/httpd/conf.d/revocator.conf', '/etc/httpd/conf.modules.d/11-revocator.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('revocator', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['mod_rev.so'])
    end

    # security for 2.4 on rhel-7
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('security', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['/etc/httpd/conf.d/mod_security.conf', '/etc/httpd/conf.modules.d/10-mod_security.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('security', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['mod_security2.so'])
    end

    # session for 2.4 on rhel-7
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('session', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['/etc/httpd/conf.modules.d/01-session.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('session', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['mod_auth_form.so', 'mod_session.so', 'mod_session_cookie.so', 'mod_session_crypto.so', 'mod_session_dbd.so'])
    end

    # ssl for 2.4 on rhel-7
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('ssl', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['/etc/httpd/conf.d/ssl.conf', '/etc/httpd/conf.modules.d/00-ssl.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('ssl', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['mod_ssl.so'])
    end

    # wsgi for 2.4 on rhel-7
    it 'returns the proper list of files to delete' do
      expect(
        delete_files_for_module('wsgi', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['/etc/httpd/conf.modules.d/10-wsgi.conf'])
    end

    it 'returns the proper list of files to load' do
      expect(
        load_files_for_module('wsgi', '2.4', 'centos', 'rhel', '7.0')
        ).to eq(['mod_wsgi.so'])
    end

  end
end
