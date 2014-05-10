require 'spec_helper'

describe 'httpd_test_default::server on omnios-151006' do
  let(:omnios_151006_default_run) do
    ChefSpec::Runner.new(
      :platform => 'omnios',
      :version => '151006'
      ) do |node|
      node.set['httpd']['service_name'] = 'omnios_151006_default'
    end.converge('httpd_test_default::server')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[omnios_151006_default]' do
      expect(omnios_151006_default_run).to create_httpd_service('omnios_151006_default').with(
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
