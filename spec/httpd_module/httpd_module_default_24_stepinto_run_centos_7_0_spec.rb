require 'spec_helper'

describe 'httpd_module::default on centos-7.0' do
  let(:httpd_module_default_22_stepinto_run_centos_7_0) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_module',
      :platform => 'centos',
      :version => '7.0'
      ) do |node|
      node.set['httpd']['version'] = '2.4'
    end.converge('httpd_module::default')
  end

  context 'when using default parameters' do
    it 'creates httpd_module[auth_basic]' do
      expect(httpd_module_default_22_stepinto_run_centos_7_0).to create_httpd_module('auth_basic')
    end

    it 'installs package[auth_basic create httpd]' do
      expect(httpd_module_default_22_stepinto_run_centos_7_0).to install_package('auth_basic create httpd').with(
        :package_name => 'httpd'
        )
    end

    it 'create execute[auth_basic create remove_package_config]' do
      expect(httpd_module_default_22_stepinto_run_centos_7_0).to_not run_execute('auth_basic create remove_package_config').with(
        :user => 'root',
        :command => 'rm -rf /etc/httpd/conf.modules.d'
        )
    end

    it 'create directory[auth_basic create /etc/httpd/conf.modules.d]' do
      expect(httpd_module_default_22_stepinto_run_centos_7_0).to create_directory('auth_basic create /etc/httpd/conf.modules.d').with(
        :owner => 'root',
        :group => 'root',
        :recursive => true
        )
    end

    it 'create template[auth_basic create /etc/httpd/conf.modules.d/auth_basic.load]' do
      expect(httpd_module_default_22_stepinto_run_centos_7_0).to create_template('auth_basic create /etc/httpd/conf.modules.d/auth_basic.load').with(
        :owner => 'root',
        :group => 'root',
        :source => 'module_load.erb',
        :mode => '0644'
        )
    end

    it 'creates httpd_module[auth_kerb]' do
      expect(httpd_module_default_22_stepinto_run_centos_7_0).to create_httpd_module('auth_kerb')
    end

    it 'installs package[auth_kerb create mod_auth_kerb]' do
      expect(httpd_module_default_22_stepinto_run_centos_7_0).to install_package('auth_kerb create mod_auth_kerb').with(
        :package_name => 'mod_auth_kerb'
        )
    end

    it 'create execute[auth_kerb create remove_package_config]' do
      expect(httpd_module_default_22_stepinto_run_centos_7_0).to_not run_execute('auth_kerb create remove_package_config').with(
        :user => 'root',
        :command => 'rm -rf /etc/httpd/conf.modules.d'
        )
    end

    it 'create directory[auth_kerb create /etc/httpd/conf.modules.d]' do
      expect(httpd_module_default_22_stepinto_run_centos_7_0).to create_directory('auth_kerb create /etc/httpd/conf.modules.d').with(
        :owner => 'root',
        :group => 'root',
        :recursive => true
        )
    end

    it 'create template[auth_kerb create /etc/httpd/conf.modules.d/auth_kerb.load]' do
      expect(httpd_module_default_22_stepinto_run_centos_7_0).to create_template('auth_kerb create /etc/httpd/conf.modules.d/auth_kerb.load').with(
        :owner => 'root',
        :group => 'root',
        :source => 'module_load.erb',
        :mode => '0644'
        )
    end
  end
end
