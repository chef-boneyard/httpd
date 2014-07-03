require 'spec_helper'

describe 'httpd_module::alias_22 on debian-7.2' do
  let(:httpd_module_alias_22_stepinto_run_debian_7_2) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_module',
      :platform => 'debian',
      :version => '7.2'
      ).converge('httpd_module::alias_22')
  end

  context 'when using default parameters' do
    it 'creates httpd_module[alias]' do
      expect(httpd_module_alias_22_stepinto_run_debian_7_2).to create_httpd_module('alias')
    end

    it 'installs package[alias create apache2]' do
      expect(httpd_module_alias_22_stepinto_run_debian_7_2).to install_package('alias create apache2').with(
        :package_name => 'apache2'
        )
    end

    it 'does not run bash[alias create remove_package_config]' do
      expect(httpd_module_alias_22_stepinto_run_debian_7_2).to_not run_bash('alias create remove_package_config')
    end

    it 'creates directory[alias create /etc/apache2/mods-available]' do
      expect(httpd_module_alias_22_stepinto_run_debian_7_2).to create_directory('alias create /etc/apache2/mods-available').with(
        :path => '/etc/apache2/mods-available',
        :owner => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates template[alias create /etc/apache2/mods-available/alias.load]' do
      expect(httpd_module_alias_22_stepinto_run_debian_7_2).to create_template('alias create /etc/apache2/mods-available/alias.load').with(
        :path => '/etc/apache2/mods-available/alias.load',
        :source => 'module_load.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'creates directory[alias create /etc/apache2/mods-enabled]' do
      expect(httpd_module_alias_22_stepinto_run_debian_7_2).to create_directory('alias create /etc/apache2/mods-enabled').with(
        :path => '/etc/apache2/mods-enabled',
        :owner => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates link[alias create /etc/apache2/mods-enabled]' do
      expect(httpd_module_alias_22_stepinto_run_debian_7_2).to create_link('alias create /etc/apache2/mods-enabled/alias.load').with(
        :target_file => '/etc/apache2/mods-enabled/alias.load',
        :to => '/etc/apache2/mods-available/alias.load'
        )
    end
  end
end
