require 'spec_helper'

describe 'httpd_config::default on amazon-2014.04' do
  let(:httpd_config_stepinto_run_amazon_2014_03) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_config',
      :platform => 'amazon',
      :version => '2014.03'
      ).converge('httpd_config::default')
  end

  context 'compiling the recipe' do
    # it 'creates httpd_config[hello]' do
    #   expect(httpd_config_stepinto_run_amazon_2014_03).to create_httpd_config('hello')
    # end
  end
end
