require 'spec_helper'

describe 'httpd_test_custom::server on centos-5.8' do
  let(:centos_5_8_custom_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'centos',
      :version => '5.8'
      ) do |node|
      node.set['httpd']['service_name'] = 'centos_5_8_custom_stepinto'
    end.converge('httpd_test_custom::server')
  end

  context 'when using custom parameters' do
    it 'creates httpd_service[centos_5_8_custom]' do
      expect(centos_5_8_custom_stepinto_run).to create_httpd_service('centos_5_8_custom_stepinto').with(
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
