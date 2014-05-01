require 'spec_helper'

describe 'crossplat_test::thing on centos-5.8' do
  let(:centos_5_8_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'crossplat_thing',
      :platform => 'centos',
      :version => '5.8'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'centos_5_8_default_stepinto'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[centos_5_8_default_stepinto]' do
      expect(centos_5_8_default_stepinto_run).to create_crossplat_thing('centos_5_8_default_stepinto')
    end

    it 'steps into crossplat_thing and writes log[message for centos-5.8]' do
      expect(centos_5_8_default_stepinto_run).to write_log('Sorry, crossplat_thing support for centos-5.8 has not yet been implemented.')
    end
  end
end
