require 'spec_helper'

describe 'httpd_test_broken::server 2.2 on ubuntu-14.04' do
  let(:ubuntu_14_04_broken_run) do
    ChefSpec::Runner.new(
      :platform => 'ubuntu',
      :version => '14.04'
      ) do |node|
      node.set['httpd']['version'] = '2.2'
    end.converge('httpd_test_broken::server')
  end

  context 'when using broken parameters' do
    it 'creates raises an error' do
      expect { ubuntu_14_04_broken_run }.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end
end
