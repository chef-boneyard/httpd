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

    it 'steps into crossplat_thing and runs ruby_block[message for amazon-2014.03]' do
      expect(amazon_2014_03_default_stepinto_run).to write_log('Sorry, crossplat_thing support for amazon-2014.03 has not yet been implemented.')
    end
  end
end
