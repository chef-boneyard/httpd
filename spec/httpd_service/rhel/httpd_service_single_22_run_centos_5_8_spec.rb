require 'spec_helper'

describe 'httpd_service::single on rhel-5.8' do
  let(:httpd_service_single_22_run_centos_5_8) do
    ChefSpec::Runner.new(
      :platform => 'centos',
      :version => '5.8'
      ).converge('httpd_service::single')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[default]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_httpd_service('default').with(
        :contact => 'webmaster@localhost',
        :hostname_lookups => 'off',
        :keepalive => true,
        :keepaliverequests => '100',
        :keepalivetimeout => '5',
        :listen_addresses => ['0.0.0.0'],
        :listen_ports => %w(80 443),
        :log_level => 'warn',
        :package_name => 'httpd',
        :run_user => 'apache',
        :run_group => 'apache',
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
