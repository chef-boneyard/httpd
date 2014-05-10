require 'spec_helper'

describe 'httpd_test_default::server on amazon-2014.03' do
  let(:amazon_2014_03_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'amazon',
      :version => '2014.03'
      ) do |node|
      node.set['httpd']['service_name'] = 'amazon_2014_03_default_stepinto'
    end.converge('httpd_test_default::server')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[amazon_2014_03_default]' do
      expect(amazon_2014_03_default_stepinto_run).to create_httpd_service('amazon_2014_03_default_stepinto').with(
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
