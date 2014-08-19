require 'spec_helper'

describe 'httpd_service::single on rhel-7.0' do
  let(:httpd_service_single_22_run_centos_7_0) do
    ChefSpec::Runner.new(
      :platform => 'centos',
      :version => '7.0'
      ).converge('httpd_service::single')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[default]' do
      expect(httpd_service_single_22_run_centos_7_0).to create_httpd_service('default').with(
        :parsed_contact => 'webmaster@localhost',
        :parsed_hostname_lookups => 'off',
        :parsed_keepalive => true,
        :parsed_keepaliverequests => '100',
        :parsed_keepalivetimeout => '5',
        :parsed_listen_addresses => ['0.0.0.0'],
        :parsed_listen_ports => %w(80 443),
        :parsed_log_level => 'warn',
        :parsed_package_name => 'httpd',
        :parsed_run_user => 'apache',
        :parsed_run_group => 'apache',
        :parsed_timeout => '400',
        :parsed_version => '2.4',
        :parsed_mpm => 'event',
        :parsed_startservers => '2',
        :parsed_minspareservers => nil,
        :parsed_maxspareservers => nil,
        :parsed_maxclients => nil,
        :parsed_maxrequestsperchild => nil,
        :parsed_minsparethreads => '25',
        :parsed_maxsparethreads => '75',
        :parsed_threadlimit => '64',
        :parsed_threadsperchild => '25',
        :parsed_maxrequestworkers => '150',
        :parsed_maxconnectionsperchild => '0'
        )
    end
  end
end
