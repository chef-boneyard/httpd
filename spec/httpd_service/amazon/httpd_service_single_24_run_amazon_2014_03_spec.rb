require 'spec_helper'

describe 'httpd_service::single on amazon-2014.03' do
  let(:httpd_service_single_24_run_amazon_2014_03) do
    ChefSpec::Runner.new(
      platform: 'amazon',
      version: '2014.03'
      ) do |node|
      node.set['httpd']['version'] = '2.4'
    end.converge('httpd_service::single')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[default]' do
      expect(httpd_service_single_24_run_amazon_2014_03).to create_httpd_service('default')
        .with(
        parsed_contact: 'webmaster@localhost',
        parsed_hostname_lookups: 'off',
        parsed_keepalive: true,
        parsed_maxkeepaliverequests: '100',
        parsed_keepalivetimeout: '5',
        parsed_listen_addresses: ['0.0.0.0'],
        parsed_listen_ports: %w(80 443),
        parsed_log_level: 'warn',
        parsed_package_name: 'httpd24',
        parsed_run_user: 'apache',
        parsed_run_group: 'apache',
        parsed_timeout: '400',
        parsed_version: '2.4',
        parsed_mpm: 'event',
        parsed_startservers: '2',
        parsed_minspareservers: nil,
        parsed_maxspareservers: nil,
        parsed_maxclients: nil,
        parsed_maxrequestsperchild: nil,
        parsed_minsparethreads: '25',
        parsed_maxsparethreads: '75',
        parsed_threadlimit: '64',
        parsed_threadsperchild: '25',
        parsed_maxrequestworkers: '150',
        parsed_maxconnectionsperchild: '0'
        )
    end
  end
end
