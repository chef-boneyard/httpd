require 'spec_helper'

describe 'httpd_test::service on omnios-151006' do
  let(:omnios_151006_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'omnios',
      :version => '151006'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'omnios_151006_default_stepinto'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[omnios_151006_default_stepinto]' do
      expect(omnios_151006_default_stepinto_run).to create_httpd_service('omnios_151006_default_stepinto')
    end

    it 'steps into httpd_service and writes log[message for omnios-151006]' do
      expect(omnios_151006_default_stepinto_run).to write_log('Sorry, httpd_service support for omnios-151006 has not yet been implemented.')
    end
  end
end
