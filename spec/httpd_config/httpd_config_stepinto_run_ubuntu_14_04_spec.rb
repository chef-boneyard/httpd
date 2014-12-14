require 'spec_helper'

describe 'httpd_config::default on ubuntu-14.04' do
  let(:httpd_config_stepinto_run_ubuntu_14_04) do
    ChefSpec::Runner.new(
      step_into: 'httpd_config',
      platform: 'ubuntu',
      version: '14.04'
      ).converge('httpd_config::default')
  end

  context 'compiling the recipe' do
    it 'creates httpd_config[hello]' do
      expect(httpd_config_stepinto_run_ubuntu_14_04).to create_httpd_config('hello')
    end

    it 'creates httpd_config[hello_again]' do
      expect(httpd_config_stepinto_run_ubuntu_14_04).to create_httpd_config('hello_again')
    end
  end

  context 'stepping into httdd_config' do
    it 'creates directory[hello create /etc/apache2/conf-available]' do
      expect(httpd_config_stepinto_run_ubuntu_14_04).to create_directory('hello create /etc/apache2/conf-available').with(
        path: '/etc/apache2/conf-available',
        owner: 'root',
        group: 'root',
        mode: '0755',
        recursive: true
        )
    end

    it 'creates directory[hello create /etc/apache2/conf-enabled]' do
      expect(httpd_config_stepinto_run_ubuntu_14_04).to create_directory('hello create /etc/apache2/conf-enabled').with(
        path: '/etc/apache2/conf-enabled',
        owner: 'root',
        group: 'root',
        mode: '0755',
        recursive: true
        )
    end

    it 'creates template[hello create /etc/apache2/conf-available/hello.conf]' do
      expect(httpd_config_stepinto_run_ubuntu_14_04).to create_template('hello create /etc/apache2/conf-available/hello.conf').with(
        path: '/etc/apache2/conf-available/hello.conf',
        owner: 'root',
        group: 'root',
        mode: '0644',
        source: 'hello.conf.erb',
        cookbook: nil
        )
    end

    it 'creates link[hello create /etc/apache2/conf-enabled/hello.conf]' do
      expect(httpd_config_stepinto_run_ubuntu_14_04).to create_link('hello create /etc/apache2/conf-enabled/hello.conf').with(
        target_file: '/etc/apache2/conf-enabled/hello.conf',
        to: '/etc/apache2/conf-available/hello.conf'
        )
    end

    it 'creates directory[hello_again create /etc/apache2-foo/conf-available]' do
      expect(httpd_config_stepinto_run_ubuntu_14_04).to create_directory('hello_again create /etc/apache2-foo/conf-available').with(
        path: '/etc/apache2-foo/conf-available',
        owner: 'root',
        group: 'root',
        mode: '0755',
        recursive: true
        )
    end

    it 'creates directory[hello_again create /etc/apache2-foo/conf-enabled]' do
      expect(httpd_config_stepinto_run_ubuntu_14_04).to create_directory('hello_again create /etc/apache2-foo/conf-enabled').with(
        path: '/etc/apache2-foo/conf-enabled',
        owner: 'root',
        group: 'root',
        mode: '0755',
        recursive: true
        )
    end

    it 'creates template[hello_again create /etc/apache2-foo/conf-available/hello_again.conf]' do
      expect(httpd_config_stepinto_run_ubuntu_14_04).to create_template('hello_again create /etc/apache2-foo/conf-available/hello_again.conf').with(
        path: '/etc/apache2-foo/conf-available/hello_again.conf',
        owner: 'root',
        group: 'root',
        mode: '0644',
        source: 'hello.conf.erb',
        cookbook: nil
        )
    end

    it 'creates link[hello_again create /etc/apache2-foo/conf-enabled/hello_again.conf]' do
      expect(httpd_config_stepinto_run_ubuntu_14_04).to create_link('hello_again create /etc/apache2-foo/conf-enabled/hello_again.conf').with(
        target_file: '/etc/apache2-foo/conf-enabled/hello_again.conf',
        to: '/etc/apache2-foo/conf-available/hello_again.conf'
        )
    end
  end
end
