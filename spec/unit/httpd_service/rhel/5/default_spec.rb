require 'spec_helper'

describe 'httpd_test_default::service on centos-5.8' do
  let(:centos_5_8_default_run) do
    ChefSpec::Runner.new(
      :platform => 'centos',
      :version => '5.8'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'centos_5_8_default'
    end.converge('httpd_test_default::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[centos_5_8_default]' do
      expect(centos_5_8_default_run).to create_httpd_service('centos_5_8_default').with(
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
