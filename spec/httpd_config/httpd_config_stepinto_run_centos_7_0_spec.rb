require 'spec_helper'

describe 'httpd_config::default on centos-7.0' do
  let(:httpd_config_stepinto_run_centos_7_0) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_config',
      :platform => 'centos',
      :version => '7.0'
      ).converge('httpd_config::default')
  end

  context 'compiling the recipe' do
    # it 'creates httpd_config[hello]' do
    #   expect(httpd_config_stepinto_run_centos_7_0).to create_httpd_config('hello')
    # end
  end
end
