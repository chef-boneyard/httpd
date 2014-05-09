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
  end
end
