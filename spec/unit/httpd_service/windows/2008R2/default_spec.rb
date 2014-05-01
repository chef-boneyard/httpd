require 'spec_helper'

describe 'httpd_test::service on windows-2008R2' do
  let(:windows_2008R2_default_run) do
    ChefSpec::Runner.new(
      :platform => 'windows',
      :version => '2008R2'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'windows_2008R2_default'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[windows_2008R2_default]' do
      expect(windows_2008R2_default_run).to create_httpd_service('windows_2008R2_default')
    end
  end
end
