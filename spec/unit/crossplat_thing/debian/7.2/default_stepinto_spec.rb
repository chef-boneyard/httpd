require 'spec_helper'

describe 'crossplat_test::thing on debian-7.2' do
  let(:debian_7_2_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'crossplat_thing',
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'debian_7_2_default_stepinto'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[debian_7_2_default_stepinto]' do
      expect(debian_7_2_default_stepinto_run).to create_crossplat_thing('debian_7_2_default_stepinto')
    end

    it 'steps into crossplat_thing and writes log[message for debian-7.2]' do
      expect(debian_7_2_default_stepinto_run).to write_log('Sorry, crossplat_thing support for debian-7.2 has not yet been implemented.')
    end
  end
end
