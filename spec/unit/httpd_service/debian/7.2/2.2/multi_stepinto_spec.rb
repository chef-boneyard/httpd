require 'spec_helper'

describe 'httpd_test_multi::server 2.2 on debian-7.2' do
  let(:debian_7_2_multi_stepinto_run) do
    ChefSpec::Runner.new(
      #      :step_into => 'httpd_service',
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['httpd']['contact'] = 'bob@computers.biz'
      node.set['httpd']['version'] = '2.2'
      node.set['httpd']['keepalive'] = false
      node.set['httpd']['keepaliverequests'] = '5678'
      node.set['httpd']['keepalivetimeout'] = '8765'
      node.set['httpd']['listen_ports'] = %w(81 444)
      node.set['httpd']['log_level'] = 'warn'
      node.set['httpd']['run_user'] = 'bob'
      node.set['httpd']['run_group'] = 'bob'
      node.set['httpd']['timeout'] = '1234'
    end.converge('httpd_test_multi::server')
  end

  context 'when compiling the recipe' do
    it 'creates group alice' do
      expect(debian_7_2_multi_stepinto_run).to create_group('alice')
    end

    it 'creates user alice' do
      expect(debian_7_2_multi_stepinto_run).to create_user('alice').with(
        :gid => 'alice'
        )
    end

    it 'creates group bob' do
      expect(debian_7_2_multi_stepinto_run).to create_group('bob')
    end

    it 'creates user bob' do
      expect(debian_7_2_multi_stepinto_run).to create_user('bob').with(
        :gid => 'bob'
        )
    end

    it 'deletes httpd_service[default]' do
      expect(debian_7_2_multi_stepinto_run).to delete_httpd_service('default')
    end

    it 'creates httpd_service[instance-1]' do
      expect(debian_7_2_multi_stepinto_run).to create_httpd_service('instance-1').with(
        :contact => 'bob@computers.biz',
        :hostname_lookups => 'off',
        :keepalive => false,
        :keepaliverequests => '5678',
        :keepalivetimeout => '8765',
        :listen_addresses => nil,
        :listen_ports => %w(81 444),
        :log_level => 'warn',
        :version => '2.2',
        :package_name => 'apache2',
        :run_user => 'bob',
        :run_group => 'bob',
        :timeout => '1234'
        )
    end

    it 'creates httpd_service[instance-2]' do
      expect(debian_7_2_multi_stepinto_run).to create_httpd_service('instance-2').with(
        :contact => 'hal@computers.biz',
        :hostname_lookups => 'off',
        :keepalive => false,
        :keepaliverequests => '2001',
        :keepalivetimeout => '0',
        :listen_addresses => nil,
        :listen_ports => %w(8080 4343),
        :log_level => 'warn',
        :version => '2.2',
        :package_name => 'apache2',
        :run_user => 'alice',
        :run_group => 'alice',
        :timeout => '4321'
        )
    end
  end

  it 'writes log[notify restart]' do
    expect(debian_7_2_multi_stepinto_run).to write_log('notify restart')
  end

  it 'writes log[notify reload]' do
    expect(debian_7_2_multi_stepinto_run).to write_log('notify reload')
  end
end
