require 'spec_helper'

describe 'crossplat_test::thing on ubuntu-12_04' do
  let(:ubuntu_12_04_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'crossplat_thing',
      :platform => 'ubuntu',
      :version => '12.04'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'ubuntu_12_04_default_stepinto'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[ubuntu_12_04_default_stepinto]' do
      expect(ubuntu_12_04_default_stepinto_run).to create_crossplat_thing('ubuntu_12_04_default_stepinto')
    end

    it 'steps into crossplat_thing and runs ruby_block[message for ubuntu-12.04]' do
      expect(ubuntu_12_04_default_stepinto_run).to run_ruby_block('message for ubuntu-12.04')
    end
  end
end
