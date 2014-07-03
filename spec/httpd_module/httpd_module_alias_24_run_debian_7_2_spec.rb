require 'spec_helper'

describe 'httpd_module::alias_24 on debian-7.2' do
  let(:httpd_module_alias_24_run_debian_7_2) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_module',
      :platform => 'debian',
      :version => '7.2'
      ).converge('httpd_module::alias_24')
  end

  context 'when using default parameters' do
    it 'creates httpd_module[alias]' do
      expect(httpd_module_alias_24_run_debian_7_2).to create_httpd_module('alias')
    end
  end
end
