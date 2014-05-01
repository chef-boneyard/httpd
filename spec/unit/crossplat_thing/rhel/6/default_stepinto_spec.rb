require 'spec_helper'

describe 'crossplat_test::thing on centos-6.4' do
  let(:centos_6_4_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'crossplat_thing',
      :platform => 'centos',
      :version => '6.4'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'centos_6_4_default_stepinto'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[centos_6_4_default_stepinto]' do
      expect(centos_6_4_default_stepinto_run).to create_crossplat_thing('centos_6_4_default_stepinto')
    end

    it 'steps into crossplat_thing and writes log[message for centos-6.4]' do
      expect(centos_6_4_default_stepinto_run).to write_log('Sorry, crossplat_thing support for centos-6.4 has not yet been implemented.')
    end
  end
end
