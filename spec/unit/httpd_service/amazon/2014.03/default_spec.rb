require 'spec_helper'

describe 'httpd_test::service on amazon-2014.03' do
  let(:amazon_2014_03_default_run) do
    ChefSpec::Runner.new(
      :platform => 'amazon',
      :version => '2014.03'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'amazon_2014_03_default'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[amazon_2014_03_default]' do
      expect(amazon_2014_03_default_run).to create_httpd_service('amazon_2014_03_default')
    end
  end
end
