require 'spec_helper'

describe 'httpd_test_broken::server 2.2 on debian-7.2' do
  let(:chef_run) do
    ChefSpec::Runner.new(
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['httpd']['version'] = '2.2'
      node.set['httpd']['minspareservers'] = '42'
    end.converge('httpd_test_broken::server')
  end

  context 'when using broken parameters' do
    it 'creates raises an error' do
      expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end
end
