require 'spec_helper'

describe 'crossplat_test::thing on smartos-5_11' do
  let(:smartos_5_11_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'crossplat_thing',
      :platform => 'smartos',
      :version => '5.11'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'smartos_5_11_default_stepinto'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[smartos_5_11_default_stepinto]' do
      expect(smartos_5_11_default_stepinto_run).to create_crossplat_thing('smartos_5_11_default_stepinto')
    end

    it 'steps into crossplat_thing and runs ruby_block[message for smartos-5.11]' do
      expect(smartos_5_11_default_stepinto_run).to run_ruby_block('message for smartos-5.11')
    end
  end
end
