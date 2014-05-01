require 'spec_helper'

describe 'httpd_test::service on omnios-151006' do
  let(:omnios_151006_default_run) do
    ChefSpec::Runner.new(
      :platform => 'omnios',
      :version => '151006'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'omnios_151006_default'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[omnios_151006_default]' do
      expect(omnios_151006_default_run).to create_httpd_service('omnios_151006_default')
    end
  end
end
