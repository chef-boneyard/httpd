require 'spec_helper'

describe 'crossplat_test::thing on omnios-151006' do
  let(:omnios_151006_default_run) do
    ChefSpec::Runner.new(
      :platform => 'omnios',
      :version => '151006'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'omnios_151006_default'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[omnios_151006_default]' do
      expect(omnios_151006_default_run).to create_crossplat_thing('omnios_151006_default')
    end
  end
end
