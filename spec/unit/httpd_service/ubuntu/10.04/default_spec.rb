require 'spec_helper'

describe 'httpd_test::service on ubuntu-10.04' do
  let(:ubuntu_10_04_default_run) do
    ChefSpec::Runner.new(
      :platform => 'ubuntu',
      :version => '10.04'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'ubuntu_10_04_default'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[ubuntu_10_04_default]' do
      expect(ubuntu_10_04_default_run).to create_httpd_service('ubuntu_10_04_default')
    end
  end
end
