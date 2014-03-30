require 'spec_helper'

describe 'crossplat_test::thing on fedora-19' do
  let(:fedora_19_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'crossplat_thing',
      :platform => 'fedora',
      :version => '19'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'fedora_19_default_stepinto'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[fedora_19_default_stepinto]' do
      expect(fedora_19_default_stepinto_run).to create_crossplat_thing('fedora_19_default_stepinto')
    end

    it 'steps into crossplat_thing and runs ruby_block[message for fedora-19]' do
      expect(fedora_19_default_stepinto_run).to write_log('Sorry, crossplat_thing support for fedora-19 has not yet been implemented.')
    end
  end
end
