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
