require 'spec_helper'

describe 'httpd_test_custom::server on omnios-151006' do
  let(:omnios_151006_custom_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'omnios',
      :version => '151006'
      ) do |node|
      node.set['httpd']['service_name'] = 'omnios_151006_custom_stepinto'
    end.converge('httpd_test_custom::server')
  end

  context 'when using custom parameters' do
    it 'creates httpd_service[omnios_151006_custom]' do
      expect(omnios_151006_custom_stepinto_run).to create_httpd_service('omnios_151006_custom_stepinto').with(
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
