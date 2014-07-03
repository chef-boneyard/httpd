require 'spec_helper'

describe 'httpd_module::alias_22 on debian-7.2' do
  let(:httpd_module_alias_22_run_debian_7_2) do
    ChefSpec::Runner.new(
      :platform => 'debian',
      :version => '7.2'
      ).converge('httpd_module::alias_22')
  end

  context 'when using default parameters' do
    it 'creates httpd_module[alias]' do
      expect(httpd_module_alias_22_run_debian_7_2).to create_httpd_module('alias')
    end
  end
end
