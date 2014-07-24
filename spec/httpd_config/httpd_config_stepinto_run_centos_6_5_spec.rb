require 'spec_helper'

describe 'httpd_config::default on centos-6.5' do
  let(:httpd_config_stepinto_run_centos_6_5) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_config',
      :platform => 'centos',
      :version => '6.5'
      ).converge('httpd_config::default')

    context 'compiling the recipe' do
      # it 'creates httpd_config[hello]' do
      #   expect(httpd_config_stepinto_run_centos_6_5).to create_httpd_config('hello')
      # end
    end
  end
end
