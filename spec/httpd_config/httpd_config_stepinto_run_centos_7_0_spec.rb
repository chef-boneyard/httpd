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
    it 'creates httpd_config[hello]' do
      expect(httpd_config_stepinto_run_centos_7_0).to create_httpd_config('hello')
    end

    it 'creates httpd_config[hello_again]' do
      expect(httpd_config_stepinto_run_centos_7_0).to create_httpd_config('hello_again')
    end
  end

  context 'stepping into httdd_config' do
    it 'creates directory[hello create /etc/httpd/conf.d]' do
      expect(httpd_config_stepinto_run_centos_7_0).to create_directory('hello create /etc/httpd/conf.d').with(
        :path => '/etc/httpd/conf.d',
        :owner => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates template[hello create /etc/httpd/conf.d/hello.conf]' do
      expect(httpd_config_stepinto_run_centos_7_0).to create_template('hello create /etc/httpd/conf.d/hello.conf').with(
        :path => '/etc/httpd/conf.d/hello.conf',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :source => 'hello.conf.erb',
        :cookbook => nil
        )
    end

    it 'creates directory[hello_again create /etc/httpd-foo/conf.d]' do
      expect(httpd_config_stepinto_run_centos_7_0).to create_directory('hello_again create /etc/httpd-foo/conf.d').with(
        :path => '/etc/httpd-foo/conf.d',
        :owner => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates template[hello_again create /etc/httpd-foo/conf.d/hello_again.conf]' do
      expect(httpd_config_stepinto_run_centos_7_0).to create_template('hello_again create /etc/httpd-foo/conf.d/hello_again.conf').with(
        :path => '/etc/httpd-foo/conf.d/hello_again.conf',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :source => 'hello.conf.erb',
        :cookbook => nil
        )
    end
  end
end
