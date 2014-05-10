require 'spec_helper'

describe 'httpd_test_custom::server on centos-6.4' do
  let(:centos_6_4_custom_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'centos',
      :version => '6.4'
      ) do |node|
      node.set['httpd']['service_name'] = 'centos_6_4_custom_stepinto'
    end.converge('httpd_test_custom::server')
  end

  context 'when using custom parameters' do
    it 'creates httpd_service[centos_6_4_custom]' do
      expect(centos_6_4_custom_stepinto_run).to create_httpd_service('centos_6_4_custom_stepinto').with(
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
