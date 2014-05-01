require 'spec_helper'

describe 'httpd_test::service on ubuntu-13.10' do
  let(:ubuntu_13_10_default_run) do
    ChefSpec::Runner.new(
      :platform => 'ubuntu',
      :version => '13.10'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'ubuntu_13_10_default'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[ubuntu_13_10_default]' do
      expect(ubuntu_13_10_default_run).to create_httpd_service('ubuntu_13_10_default')
    end
  end
end
