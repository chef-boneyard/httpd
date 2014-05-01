require 'spec_helper'

describe 'httpd_test::service on smartos-5_11' do
  let(:smartos_5_11_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'smartos',
      :version => '5.11'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'smartos_5_11_default_stepinto'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[smartos_5_11_default_stepinto]' do
      expect(smartos_5_11_default_stepinto_run).to create_httpd_service('smartos_5_11_default_stepinto')
    end

    it 'steps into httpd_service and writes log[message for smartos-5.11]' do
      expect(smartos_5_11_default_stepinto_run).to write_log('Sorry, httpd_service support for smartos-5.11 has not yet been implemented.')
    end
  end
end
