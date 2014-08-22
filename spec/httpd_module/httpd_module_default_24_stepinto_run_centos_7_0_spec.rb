require 'spec_helper'

describe 'httpd_module::default on centos-7.0' do
  let(:httpd_module_default_24_stepinto_run_centos_7_0) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_module',
      :platform => 'centos',
      :version => '7.0'
      ) do |node|
      node.set['httpd']['version'] = '2.4'
    end.converge('httpd_module::default')
  end

  let(:auth_basic_load_content) do
    'LoadModule auth_basic_module /usr/lib64/httpd/modules/mod_auth_basic.so'
  end

  let(:auth_kerb_load_content) do
    'LoadModule auth_kerb_module /usr/lib64/httpd/modules/mod_auth_kerb.so'
  end

  context 'when using default parameters' do
    it 'creates httpd_module[auth_basic]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to create_httpd_module('auth_basic')
    end

    it 'installs package[auth_basic create httpd]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to install_package('auth_basic create httpd').with(
        :package_name => 'httpd'
        )
    end

    it 'deletes file[auth_basic create /etc/httpd/conf.d/autoindex.conf]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to_not delete_file('auth_basic create /etc/httpd/conf.d/autoindex.conf').with(
        :path => '/etc/httpd/conf.d/autoindex.conf'
        )
    end

    it 'deletes file[auth_basic create /etc/httpd/conf.d/README]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to_not delete_file('auth_basic create /etc/httpd/conf.d/README').with(
        :path => '/etc/httpd/conf.d/README'
        )
    end

    it 'deletes file[auth_basic create /etc/httpd/conf.d/userdir.conf]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to_not delete_file('auth_basic create /etc/httpd/conf.d/userdir.conf').with(
        :path => '/etc/httpd/conf.d/userdir.conf'
        )
    end

    it 'deletes file[auth_basic create /etc/httpd/conf.d/welcome.conf]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to_not delete_file('auth_basic create /etc/httpd/conf.d/welcome.conf').with(
        :path => '/etc/httpd/conf.d/welcome.conf'
        )
    end

    it 'deletes file[auth_basic create /etc/httpd/conf.modules.d/00-base.conf]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to_not delete_file('auth_basic create /etc/httpd/conf.modules.d/00-base.conf').with(
        :path => '/etc/httpd/conf.modules.d/00-base.conf'
        )
    end

    it 'deletes file[auth_basic create /etc/httpd/conf.modules.d/00-dav.conf]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to_not delete_file('auth_basic create /etc/httpd/conf.modules.d/00-dav.conf').with(
        :path => '/etc/httpd/conf.modules.d/00-dav.conf'
        )
    end

    it 'deletes file[auth_basic create /etc/httpd/conf.modules.d/00-lua.conf]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to_not delete_file('auth_basic create /etc/httpd/conf.modules.d/00-lua.conf').with(
        :path => '/etc/httpd/conf.modules.d/00-lua.conf'
        )
    end

    it 'deletes file[auth_basic create /etc/httpd/conf.modules.d/00-mpm.conf]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to_not delete_file('auth_basic create /etc/httpd/conf.modules.d/00-mpm.conf').with(
        :path => '/etc/httpd/conf.modules.d/00-mpm.conf'
        )
    end

    it 'deletes file[auth_basic create /etc/httpd/conf.modules.d/00-proxy.conf]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to_not delete_file('auth_basic create /etc/httpd/conf.modules.d/00-proxy.conf').with(
        :path => '/etc/httpd/conf.modules.d/00-proxy.conf'
        )
    end

    it 'deletes file[auth_basic create /etc/httpd/conf.modules.d/00-systemd.conf]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to_not delete_file('auth_basic create /etc/httpd/conf.modules.d/00-systemd.conf').with(
        :path => '/etc/httpd/conf.modules.d/00-systemd.conf'
        )
    end

    it 'deletes file[auth_basic create /etc/httpd/conf.modules.d/01-cgi.conf]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to_not delete_file('auth_basic create /etc/httpd/conf.modules.d/01-cgi.conf').with(
        :path => '/etc/httpd/conf.modules.d/01-cgi.conf'
        )
    end

    it 'create directory[auth_basic create /etc/httpd/conf.modules.d]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to create_directory('auth_basic create /etc/httpd/conf.modules.d').with(
        :owner => 'root',
        :group => 'root',
        :recursive => true
        )
    end

    it 'create template[auth_basic create /etc/httpd/conf.modules.d/auth_basic.load]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to create_template('auth_basic create /etc/httpd/conf.modules.d/auth_basic.load').with(
        :owner => 'root',
        :group => 'root',
        :source => 'module_load.erb',
        :mode => '0644'
        )
    end

    it 'renders file[auth_basic create /etc/httpd/conf.modules.d/auth_basic.load]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to render_file('auth_basic create /etc/httpd/conf.modules.d/auth_basic.load').with_content(
        auth_basic_load_content
        )
    end

    it 'creates httpd_module[auth_kerb]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to create_httpd_module('auth_kerb')
    end

    it 'installs package[auth_kerb create mod_auth_kerb]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to install_package('auth_kerb create mod_auth_kerb').with(
        :package_name => 'mod_auth_kerb'
        )
    end

    it 'deletes file[auth_kerb create /etc/httpd/conf.modules.d/10-auth_kerb.conf]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to_not delete_file('auth_kerb create /etc/httpd/conf.modules.d/10-auth_kerb.conf').with(
        :path => '/etc/httpd/conf.modules.d/10-auth_kerb.conf'
        )
    end

    it 'create directory[auth_kerb create /etc/httpd/conf.modules.d]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to create_directory('auth_kerb create /etc/httpd/conf.modules.d').with(
        :owner => 'root',
        :group => 'root',
        :recursive => true
        )
    end

    it 'create template[auth_kerb create /etc/httpd/conf.modules.d/auth_kerb.load]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to create_template('auth_kerb create /etc/httpd/conf.modules.d/auth_kerb.load').with(
        :owner => 'root',
        :group => 'root',
        :source => 'module_load.erb',
        :mode => '0644'
        )
    end

    it 'renders file[auth_kerb create /etc/httpd/conf.modules.d/auth_kerb.load]' do
      expect(httpd_module_default_24_stepinto_run_centos_7_0).to render_file('auth_kerb create /etc/httpd/conf.modules.d/auth_kerb.load').with_content(
        auth_kerb_load_content
        )
    end
  end
end
