require 'spec_helper'

describe 'httpd_module_test::default' do
  cached(:centos_5_module_22) do
    ChefSpec::ServerRunner.new(
      step_into: 'httpd_module',
      platform: 'centos',
      version: '5.11'
    ) do |node|
      node.normal['httpd']['version'] = '2.2'
    end.converge('httpd_module_test::default')
  end

  cached(:auth_basic_load_content) do
    'LoadModule auth_basic_module /usr/lib64/httpd/modules/mod_auth_basic.so'
  end

  cached(:expires_load_content) do
    'LoadModule expires_module /usr/lib64/httpd/modules/mod_expires.so'
  end

  # test recipe compilation
  context 'when compiling the recipe' do
    it 'creates httpd_module[auth_basic]' do
      expect(centos_5_module_22).to create_httpd_module('auth_basic')
    end

    it 'creates httpd_module[expires]' do
      expect(centos_5_module_22).to create_httpd_module('expires')
    end
  end

  context 'when stepping into httpd_module' do
    it 'installs package[httpd]' do
      expect(centos_5_module_22).to install_package('httpd')
        .with(
          package_name: 'httpd'
        )
    end

    it 'create directory[/etc/httpd-default/conf.d]' do
      expect(centos_5_module_22).to create_directory('/etc/httpd-default/conf.d')
        .with(
          owner: 'root',
          group: 'root',
          recursive: true
        )
    end

    # auth_basic
    it 'create template[/etc/httpd-default/conf.d/auth_basic.load]' do
      expect(centos_5_module_22).to create_template('/etc/httpd-default/conf.d/auth_basic.load')
        .with(
          owner: 'root',
          group: 'root',
          source: 'module_load.erb',
          mode: '0644'
        )
    end

    it 'renders file[/etc/httpd-default/conf.d/auth_basic.load]' do
      expect(centos_5_module_22).to render_file('/etc/httpd-default/conf.d/auth_basic.load')
        .with_content(
          auth_basic_load_content
        )
    end

    it 'deletes file[/etc/httpd-default/conf.d/auth_kerb.conf]' do
      expect(centos_5_module_22).to_not delete_file('/etc/httpd-default/conf.d/auth_kerb.conf')
        .with(
          path: '/etc/httpd-default/conf.d/auth_kerb.conf'
        )
    end

    it 'create directory[/etc/httpd-default/conf.d]' do
      expect(centos_5_module_22).to create_directory('/etc/httpd-default/conf.d')
        .with(
          owner: 'root',
          group: 'root',
          recursive: true
        )
    end

    it 'create template[/etc/httpd-default/conf.d/expires.load]' do
      expect(centos_5_module_22).to create_template('/etc/httpd-default/conf.d/expires.load')
        .with(
          owner: 'root',
          group: 'root',
          source: 'module_load.erb',
          mode: '0644'
        )
    end

    it 'renders file[/etc/httpd-default/conf.d/expires.load]' do
      expect(centos_5_module_22).to render_file('/etc/httpd-default/conf.d/expires.load')
        .with_content(
          expires_load_content
        )
    end
  end
end
