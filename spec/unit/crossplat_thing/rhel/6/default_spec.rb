require 'spec_helper'

describe 'crossplat_test::thing on centos-6.4' do
  let(:centos_6_4_default_run) do
    ChefSpec::Runner.new(
      :platform => 'centos',
      :version => '6.4'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'centos_6_4_default'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[centos_6_4_default]' do
      expect(centos_6_4_default_run).to create_crossplat_thing('centos_6_4_default')
    end
  end
end
