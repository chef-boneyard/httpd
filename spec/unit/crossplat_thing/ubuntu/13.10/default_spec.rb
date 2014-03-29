require 'spec_helper'

describe 'crossplat_test::thing on ubuntu-13.10' do
  let(:ubuntu_13_10_default_run) do
    ChefSpec::Runner.new(
      :platform => 'ubuntu',
      :version => '13.10'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'ubuntu_13_10_default'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[ubuntu_13_10_default]' do
      expect(ubuntu_13_10_default_run).to create_crossplat_thing('ubuntu_13_10_default')
    end
  end
end
