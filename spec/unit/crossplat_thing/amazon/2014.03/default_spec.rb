require 'spec_helper'

describe 'crossplat_test::thing on amazon-2014.03' do
  let(:amazon_2014_03_default_run) do
    ChefSpec::Runner.new(
      :platform => 'amazon',
      :version => '2014.03'
      ) do |node|
      node.set['crossplat']['thing']['resource_name'] = 'amazon_2014_03_default'
    end.converge('crossplat_test::thing')
  end

  context 'when using default parameters' do
    it 'creates crossplat_thing[amazon_2014_03_default]' do
      expect(amazon_2014_03_default_run).to create_crossplat_thing('amazon_2014_03_default')
    end
  end
end
