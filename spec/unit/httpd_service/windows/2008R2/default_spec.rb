require 'spec_helper'

describe 'httpd_test_default::server on windows-2008R2' do
  let(:windows_2008R2_default_run) do
    ChefSpec::Runner.new(
      :platform => 'windows',
      :version => '2008R2'
      ) do |node|
      node.set['httpd']['service_name'] = 'windows_2008R2_default'
    end.converge('httpd_test_default::server')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[windows_2008R2_default]' do
      expect(windows_2008R2_default_run).to create_httpd_service('windows_2008R2_default')
    end
  end
end
