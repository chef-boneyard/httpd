require 'spec_helper'

describe 'httpd_test_broken::server 2.4 on debian-7.2' do
  let(:debian_7_2_broken_run) do
    ChefSpec::Runner.new(
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['httpd']['version'] = '2.4'
    end.converge('httpd_test_broken::server')
  end

  context 'when using broken parameters' do
    it 'creates raises an error' do
      expect { debian_7_2_broken_run }.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end
end
