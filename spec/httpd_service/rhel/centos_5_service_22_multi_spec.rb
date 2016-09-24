require 'spec_helper'

describe 'httpd_service_test::multi' do
  before do
    allow(Chef::Platform::ServiceHelpers).to receive(:service_resource_providers).and_return(
      [:redhat]
    )
  end

  cached(:centos_5_service_22_multi) do
    ChefSpec::ServerRunner.new(
      platform: 'centos',
      version: '5.11'
    ) do |node|
      node.default['httpd']['contact'] = 'bob@computers.biz'
      node.default['httpd']['version'] = '2.2'
      node.default['httpd']['keepalive'] = false
      node.default['httpd']['maxkeepaliverequests'] = '5678'
      node.default['httpd']['keepalivetimeout'] = '8765'
      node.default['httpd']['listen_addresses'] = ['0.0.0.0']
      node.default['httpd']['listen_ports'] = %w(81 444)
      node.default['httpd']['log_level'] = 'warn'
      node.default['httpd']['run_user'] = 'bob'
      node.default['httpd']['run_group'] = 'bob'
      node.default['httpd']['timeout'] = '1234'
      node.default['httpd']['mpm'] = 'prefork'
    end.converge('httpd_service_test::multi')
  end

  context 'when compiling the test recipe' do
    it 'creates group[alice]' do
      expect(centos_5_service_22_multi).to create_group('alice')
    end

    it 'creates user[alice]' do
      expect(centos_5_service_22_multi).to create_user('alice')
    end

    it 'creates group[bob]' do
      expect(centos_5_service_22_multi).to create_group('bob')
    end

    it 'creates user[bob]' do
      expect(centos_5_service_22_multi).to create_user('bob')
    end

    it 'creates httpd_service[instance-1]' do
      expect(centos_5_service_22_multi).to create_httpd_service('instance-2')
        .with(
          contact: 'bob@computers.biz',
          hostname_lookups: 'off',
          keepalive: false,
          keepalivetimeout: '8765',
          listen_addresses: ['0.0.0.0'],
          listen_ports: %w(81 444),
          log_level: 'warn',
          maxkeepaliverequests: '5678',
          timeout: '1234'
        )
    end
  end
end
