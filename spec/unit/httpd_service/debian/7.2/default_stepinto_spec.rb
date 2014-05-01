require 'spec_helper'

describe 'httpd_test::service on debian-7.2' do
  let(:debian_7_2_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'debian_7_2_default_stepinto'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[debian_7_2_default_stepinto]' do
      expect(debian_7_2_default_stepinto_run).to create_httpd_service('debian_7_2_default_stepinto')
    end

    it 'steps into httpd_service and writes log[message for debian-7.2]' do
      expect(debian_7_2_default_stepinto_run).to write_log('Sorry, httpd_service support for debian-7.2 has not yet been implemented.')
    end
  end
end
