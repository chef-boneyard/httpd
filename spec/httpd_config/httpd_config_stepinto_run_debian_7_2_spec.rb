require 'spec_helper'

describe 'httpd_config::default on debian-7.2' do
  let(:httpd_config_stepinto_run_debian_7_2) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_config',
      :platform => 'debian',
      :version => '7.2'
      ).converge('httpd_config::default')

    context 'compiling the recipe' do
      # it 'creates httpd_config[hello]' do
      #   expect(httpd_config_stepinto_run_debian_7_2).to create_httpd_config('hello')
      # end
    end
  end
end
