require 'spec_helper'

describe 'httpd_test_default::server on centos-6.4' do
  let(:centos_6_4_default_run) do
    ChefSpec::Runner.new(
      :platform => 'centos',
      :version => '6.4'
      ) do |node|
      node.set['httpd']['service_name'] = 'centos_6_4_default'
    end.converge('httpd_test_default::server')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[centos_6_4_default]' do
      expect(centos_6_4_default_run).to create_httpd_service('centos_6_4_default').with(
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
