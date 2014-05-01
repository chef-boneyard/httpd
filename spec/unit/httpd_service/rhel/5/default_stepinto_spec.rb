require 'spec_helper'

describe 'httpd_test::service on centos-5.8' do
  let(:centos_5_8_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'centos',
      :version => '5.8'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'centos_5_8_default_stepinto'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[centos_5_8_default_stepinto]' do
      expect(centos_5_8_default_stepinto_run).to create_httpd_service('centos_5_8_default_stepinto')
    end

    it 'steps into httpd_service and writes log[message for centos-5.8]' do
      expect(centos_5_8_default_stepinto_run).to write_log('Sorry, httpd_service support for centos-5.8 has not yet been implemented.')
    end
  end
end
