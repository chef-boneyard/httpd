require 'spec_helper'

describe 'httpd_test_default::server 2.2 on debian-7.2' do
  let(:debian_7_2_default_run) do
    ChefSpec::Runner.new(
      :platform => 'debian',
      :version => '7.2'
      ).converge('httpd_test_default::server')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[debian_7_2_default]' do
      expect(debian_7_2_default_run).to create_httpd_service('default').with(
        :contact => 'webmaster@localhost',
        :hostname_lookups => 'off',
        :keepalive => true,
        :keepaliverequests => '100',
        :keepalivetimeout => '5',
        :listen_addresses => nil,
        :listen_ports => %w(80 443),
        :log_level => 'warn',
        :package_name => 'apache2',
        :run_user => 'www-data',
        :run_group => 'www-data',
        :timeout => '400',
        :version => '2.2',
        :mpm => 'worker',
        :startservers => '2',
        :minspareservers => nil,
        :maxspareservers => nil,
        :maxclients => '150',
        :maxrequestsperchild => '0',
        :minsparethreads => '25',
        :maxsparethreads => '75',
        :threadlimit => '64',
        :threadsperchild => '25',
        :maxrequestworkers => nil,
        :maxconnectionsperchild => nil
        )
    end
  end
end
