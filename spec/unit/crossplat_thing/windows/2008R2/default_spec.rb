require 'spec_helper'

describe 'crossplat_test::thing on windows-2008R2' do
  let(:windows_2008R2_default_run) do
    ChefSpec::Runner.new(
      :platform => 'windows',
      :version => '2008R2'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'windows_2008R2_default'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[windows_2008R2_default]' do
      expect(windows_2008R2_default_run).to create_crossplat_thing('windows_2008R2_default')
    end
  end
end
