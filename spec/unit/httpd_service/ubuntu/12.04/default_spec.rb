require 'spec_helper'

describe 'httpd_test_default::server on ubuntu-12.04' do
  let(:ubuntu_12_04_default_run) do
    ChefSpec::Runner.new(
      :platform => 'ubuntu',
      :version => '12.04'
      ) do |node|
      node.set['httpd']['service_name'] = 'ubuntu_12_04_default'
    end.converge('httpd_test_default::server')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[ubuntu_12_04_default]' do
      expect(ubuntu_12_04_default_run).to create_httpd_service('ubuntu_12_04_default').with(
        :version => '2.2',
        :listen_addresses => nil,
        :listen_ports => %w(80 443),
        :contact => 'webmaster@localhost',
        :timeout => '400',
        :keepalive => true,
        :keepaliverequests => '100',
        :keepalivetimeout => '5'
        )
    end
  end
end
