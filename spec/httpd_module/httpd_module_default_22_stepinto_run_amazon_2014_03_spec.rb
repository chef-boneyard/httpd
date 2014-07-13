require 'spec_helper'

describe 'httpd_module::default on amazon-2014.04' do
  let(:httpd_module_default_22_stepinto_run_amazon_2014_03) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_module',
      :platform => 'amazon',
      :version => '2014.03'
      ) do |node|
      node.set['httpd']['version'] = '2.2'
    end.converge('httpd_module::default')
  end

  context 'when using default parameters' do
    it 'creates httpd_module[auth_basic]' do
      expect(httpd_module_default_22_stepinto_run_amazon_2014_03).to create_httpd_module('auth_basic')
    end

    it 'installs package[auth_basic create httpd24]' do
      expect(httpd_module_default_22_stepinto_run_amazon_2014_03).to install_package('auth_basic create httpd').with(
        :package_name => 'httpd'
        )
    end

    it 'creates httpd_module[auth_kerb]' do
      expect(httpd_module_default_22_stepinto_run_amazon_2014_03).to create_httpd_module('auth_kerb')
    end

    it 'installs package[auth_kerb create mod_auth_kerb]' do
      expect(httpd_module_default_22_stepinto_run_amazon_2014_03).to install_package('auth_kerb create mod_auth_kerb').with(
        :package_name => 'mod_auth_kerb'
        )
    end
  end
end
