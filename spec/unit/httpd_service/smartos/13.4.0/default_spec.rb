require 'spec_helper'

describe 'httpd_test::service on smartos-13.4.0' do
  let(:smartos_13_4_0_default_run) do
    ChefSpec::Runner.new(
      :platform => 'smartos',
      :version => '5.11'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'smartos_13_4_0_default'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[smartos_13_4_0_default]' do
      expect(smartos_13_4_0_default_run).to create_httpd_service('smartos_13_4_0_default')
    end
  end
end
