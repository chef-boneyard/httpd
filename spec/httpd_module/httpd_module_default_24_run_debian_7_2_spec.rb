require 'spec_helper'

describe 'httpd_module::default on debian-7.2' do
  let(:httpd_module_alias_24_run_debian_7_2) do
    ChefSpec::Runner.new(
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['httpd']['version'] = '2.2'
    end.converge('httpd_module::default')
  end

  context 'when using default parameters' do
    it 'creates httpd_module[auth_basic]' do
      expect(httpd_module_alias_24_run_debian_7_2).to create_httpd_module('auth_basic')
    end
  end
end
