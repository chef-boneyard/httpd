require 'spec_helper'

describe 'httpd_service::single on debian-7.2' do
  let(:httpd_service_single_24_run_debian_7_2) do
    ChefSpec::Runner.new(
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['httpd']['version'] = '2.4'
    end.converge('httpd_service::single')
  end

  context 'when using broken parameters' do
    it 'creates raises an error' do
      expect { httpd_service_single_24_run_debian_7_2 }.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end
end
