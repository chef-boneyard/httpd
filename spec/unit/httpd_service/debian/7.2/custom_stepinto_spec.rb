require 'spec_helper'

describe 'httpd_test_custom::service on debian-7.2' do
  let(:debian_7_2_custom_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'debian_7_2_custom_stepinto'
    end.converge('httpd_test_custom::service')
  end

  context 'when using custom parameters' do
    it 'creates httpd_service[debian_7_2_custom]' do
      expect(debian_7_2_custom_stepinto_run).to create_httpd_service('debian_7_2_custom_stepinto').with(
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
