require 'spec_helper'

describe 'httpd_test_default::service on amazon-2014.03' do
  let(:amazon_2014_03_default_run) do
    ChefSpec::Runner.new(
      :platform => 'amazon',
      :version => '2014.03'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'amazon_2014_03_default'
    end.converge('httpd_test_default::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[amazon_2014_03_default]' do
      expect(amazon_2014_03_default_run).to create_httpd_service('amazon_2014_03_default').with(
        :version => '2.4',
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
