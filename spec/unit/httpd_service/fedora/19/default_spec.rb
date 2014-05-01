require 'spec_helper'

describe 'httpd_test::service on fedora-19' do
  let(:fedora_19_default_run) do
    ChefSpec::Runner.new(
      :platform => 'fedora',
      :version => '19'
      ) do |node|
      node.set['httpd']['service']['resource_name'] = 'fedora_19_default'
    end.converge('httpd_test::service')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[fedora_19_default]' do
      expect(fedora_19_default_run).to create_httpd_service('fedora_19_default')
    end
  end
end
