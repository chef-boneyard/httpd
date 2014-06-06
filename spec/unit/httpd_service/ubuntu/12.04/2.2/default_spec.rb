require 'spec_helper'

describe 'httpd_test_default::server 2.2 on ubuntu-12.04' do
  let(:ubuntu_12_04_default_run) do
    ChefSpec::Runner.new(
      :platform => 'ubuntu',
      :version => '12.04'
      ).converge('httpd_test_default::server')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[ubuntu_12_04_default]' do
      expect(ubuntu_12_04_default_run).to create_httpd_service('default').with(
        :contact => 'webmaster@localhost',
        :hostname_lookups => 'off',
        :keepalive => true,
        :keepaliverequests => '100',
        :keepalivetimeout => '5',
        :listen_addresses => nil,
        :listen_ports => %w(80 443),
        :log_level => 'warn',
        :version => '2.2',
        :package_name => 'apache2',
        :run_user => 'www-data',
        :run_group => 'www-data',
        :timeout => '400'
        )
    end
  end
end
