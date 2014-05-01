require 'spec_helper'

describe 'crossplat_test::thing on fedora-19' do
  let(:fedora_19_default_run) do
    ChefSpec::Runner.new(
      :platform => 'fedora',
      :version => '19'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'fedora_19_default'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[fedora_19_default]' do
      expect(fedora_19_default_run).to create_crossplat_thing('fedora_19_default')
    end
  end
end
