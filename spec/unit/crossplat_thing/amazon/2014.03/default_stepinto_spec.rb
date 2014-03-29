require 'spec_helper'

describe 'crossplat_test::thing on amazon-2014.03' do
  let(:amazon_2014_03_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'crossplat_thing',
      :platform => 'amazon',
      :version => '2014.03'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'amazon_2014_03_default_stepinto'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[amazon_2014_03_default_stepinto]' do
      expect(amazon_2014_03_default_stepinto_run).to create_crossplat_thing('amazon_2014_03_default_stepinto')
    end

    it 'steps into crossplat_thing and runs ruby_block[message for amazon-2013.03]' do
      expect(amazon_2014_03_default_stepinto_run).to run_ruby_block('message for amazon-2014.03')
    end
  end
end
