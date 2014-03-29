require 'spec_helper'

describe 'crossplat_test::thing on centos-5.8' do
  let(:centos_5_8_default_run) do
    ChefSpec::Runner.new(
      :platform => 'centos',
      :version => '5.8'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'centos_5_8_default'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[centos_5_8_default]' do
      expect(centos_5_8_default_run).to create_crossplat_thing('centos_5_8_default')
    end
  end
end
