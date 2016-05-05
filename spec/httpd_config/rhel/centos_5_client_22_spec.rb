require 'spec_helper'

describe 'httpd_config_test::default' do
  cached(:centos_5_client_22) do
    ChefSpec::ServerRunner.new(
      step_into: 'httpd_config',
      platform: 'centos',
      version: '5.11'
    ).converge('httpd_config_test::default')
  end

  context 'compiling the recipe' do
    it 'creates httpd_config[hello]' do
      expect(centos_5_client_22).to create_httpd_config('hello')
    end

    it 'creates httpd_config[hello_again]' do
      expect(centos_5_client_22).to create_httpd_config('hello_again')
    end
  end

  context 'stepping into http_config' do
    it 'creates directory[/etc/httpd-default/conf.d]' do
      expect(centos_5_client_22).to create_directory('/etc/httpd-default/conf.d')
        .with(
          path: '/etc/httpd-default/conf.d',
          owner: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates template[/etc/httpd-default/conf.d/hello.conf]' do
      expect(centos_5_client_22).to create_template('/etc/httpd-default/conf.d/hello.conf')
        .with(
          path: '/etc/httpd-default/conf.d/hello.conf',
          owner: 'root',
          group: 'root',
          mode: '0644',
          source: 'hello.conf.erb',
          cookbook: nil
        )
    end

    it 'creates directory[/etc/httpd-foo/conf.d]' do
      expect(centos_5_client_22).to create_directory('/etc/httpd-foo/conf.d')
        .with(
          path: '/etc/httpd-foo/conf.d',
          owner: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates template[/etc/httpd-foo/conf.d/hello_again.conf]' do
      expect(centos_5_client_22).to create_template('/etc/httpd-foo/conf.d/hello_again.conf')
        .with(
          path: '/etc/httpd-foo/conf.d/hello_again.conf',
          owner: 'root',
          group: 'root',
          mode: '0644',
          source: 'hello.conf.erb',
          cookbook: nil
        )
    end
  end
end
