require 'spec_helper'

describe 'httpd_test_custom::service on smartos-13.4.0' do
  let(:smartos_13_4_0_custom_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'smartos',
      :version => '5.11'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'smartos_13_4_0_custom_stepinto'
    end.converge('httpd_test_custom::service')
  end

  context 'when using custom parameters' do
    it 'creates httpd_service[smartos_13_4_0_custom]' do
      expect(smartos_13_4_0_custom_stepinto_run).to create_httpd_service('smartos_13_4_0_custom_stepinto').with(
        :version => '2.4',
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
