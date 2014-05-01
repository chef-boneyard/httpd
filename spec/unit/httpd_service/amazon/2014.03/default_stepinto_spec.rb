require 'spec_helper'

describe 'httpd_test::service on amazon-2014.03' do
  let(:amazon_2014_03_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'amazon',
      :version => '2014.03'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'amazon_2014_03_default_stepinto'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[amazon_2014_03_default_stepinto]' do
      expect(amazon_2014_03_default_stepinto_run).to create_httpd_service('amazon_2014_03_default_stepinto')
    end

    it 'steps into httpd_service and runs ruby_block[message for amazon-2014.03]' do
      expect(amazon_2014_03_default_stepinto_run).to write_log('Sorry, httpd_service support for amazon-2014.03 has not yet been implemented.')
    end
  end
end
