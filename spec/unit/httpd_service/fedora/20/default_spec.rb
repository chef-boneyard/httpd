require 'spec_helper'

describe 'httpd_test_default::server on fedora-20' do
  let(:fedora_20_default_run) do
    ChefSpec::Runner.new(
      :platform => 'fedora',
      :version => '20'
      ) do |node|
      node.set['httpd']['service_name'] = 'fedora_20_default'
    end.converge('httpd_test_default::server')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[fedora_20_default]' do
      expect(fedora_20_default_run).to create_httpd_service('fedora_20_default').with(
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
