require 'spec_helper'

describe 'httpd_test_custom::server on ubuntu-14.04' do
  let(:ubuntu_14_04_custom_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'ubuntu',
      :version => '14.04'
      ) do |node|
      node.set['httpd']['service_name'] = 'ubuntu_14_04_custom_stepinto'
    end.converge('httpd_test_custom::server')
  end

  context 'when using custom parameters' do
    it 'creates httpd_service[ubuntu_14_04_custom]' do
      expect(ubuntu_14_04_custom_stepinto_run).to create_httpd_service('ubuntu_14_04_custom_stepinto').with(
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
