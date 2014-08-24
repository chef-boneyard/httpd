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
      expect(httpd_service_single_22_run_centos_5_8).to create_httpd_service('default')
        .with(
        :parsed_contact => 'webmaster@localhost',
        :parsed_hostname_lookups => 'off',
        :parsed_keepalive => true,
        :parsed_maxkeepaliverequests => '100',
        :parsed_keepalivetimeout => '5',
        :parsed_listen_addresses => ['0.0.0.0'],
        :parsed_listen_ports => %w(80 443),
        :parsed_log_level => 'warn',
        :parsed_package_name => 'httpd',
        :parsed_run_user => 'apache',
        :parsed_run_group => 'apache',
        :parsed_timeout => '400',
        :parsed_version => '2.2',
        :parsed_mpm => 'worker',
        :parsed_startservers => '2',
        :parsed_minspareservers => nil,
        :parsed_maxspareservers => nil,
        :parsed_maxclients => '150',
        :parsed_maxrequestsperchild => '0',
        :parsed_minsparethreads => '25',
        :parsed_maxsparethreads => '75',
        :parsed_threadlimit => '64',
        :parsed_threadsperchild => '25',
        :parsed_maxrequestworkers => nil,
        :parsed_maxconnectionsperchild => nil
        )
    end
  end
end
