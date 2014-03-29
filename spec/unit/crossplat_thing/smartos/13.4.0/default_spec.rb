require 'spec_helper'

describe 'crossplat_test::thing on smartos-13.4.0' do
  let(:smartos_13_4_0_default_run) do
    ChefSpec::Runner.new(
      :platform => 'smartos',
      :version => '5.11'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'smartos_13_4_0_default'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[smartos_13_4_0_default]' do
      expect(amazon_2014_03_default_run).to create_crossplat_thing('smartos_13_4_0_default')
    end
  end
end
