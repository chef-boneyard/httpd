require 'spec_helper'

describe 'crossplat_test::thing on omnios-151006' do
  let(:omnios_151006_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'crossplat_thing',
      :platform => 'omnios',
      :version => '151006'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'omnios_151006_default_stepinto'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[omnios_151006_default_stepinto]' do
      expect(omnios_151006_default_stepinto_run).to create_crossplat_thing('omnios_151006_default_stepinto')
    end

    it 'steps into crossplat_thing and runs ruby_block[message for omnios-151006]' do
      expect(omnios_151006_default_stepinto_run).to run_ruby_block('message for omnios-151006')
    end
  end
end
