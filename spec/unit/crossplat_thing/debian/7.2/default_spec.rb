require 'spec_helper'

describe 'crossplat_test::thing on debian-7.2' do
  let(:debian_7_2_default_run) do
    ChefSpec::Runner.new(
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'debian_7_2_default'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[debian_7_2_default]' do
      expect(debian_7_2_default_run).to create_crossplat_thing('debian_7_2_default')
    end
  end
end
