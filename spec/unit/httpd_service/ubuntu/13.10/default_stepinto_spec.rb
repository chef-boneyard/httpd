require 'spec_helper'

describe 'httpd_test::service on ubuntu-13_10' do
  let(:ubuntu_13_10_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'ubuntu',
      :version => '13.10'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'ubuntu_13_10_default_stepinto'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[ubuntu_13_10_default_stepinto]' do
      expect(ubuntu_13_10_default_stepinto_run).to create_httpd_service('ubuntu_13_10_default_stepinto')
    end
  end
end
