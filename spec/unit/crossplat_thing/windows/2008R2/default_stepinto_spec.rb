require 'spec_helper'

describe 'crossplat_test::thing on windows-2008R2' do
  let(:windows_2008R2_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'crossplat_thing',
      :platform => 'windows',
      :version => '2008R2'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'windows_2008R2_default_stepinto'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[windows_2008R2_default_stepinto]' do
      expect(windows_2008R2_default_stepinto_run).to create_crossplat_thing('windows_2008R2_default_stepinto')
    end

    # FIXME: weird.. goes in as 2008R2, comes out as 6.1.7600
    it 'steps into crossplat_thing and runs ruby_block[message for windows-6.1.7600]' do
      expect(windows_2008R2_default_stepinto_run).to run_ruby_block('message for windows-6.1.7600')
    end
  end
end
