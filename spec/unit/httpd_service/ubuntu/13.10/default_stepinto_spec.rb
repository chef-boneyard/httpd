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

    it 'steps into httpd_service and writes log[message for ubuntu-13.10]' do
      expect(ubuntu_13_10_default_stepinto_run).to write_log('Sorry, httpd_service support for ubuntu-13.10 has not yet been implemented.')
    end
  end
end
