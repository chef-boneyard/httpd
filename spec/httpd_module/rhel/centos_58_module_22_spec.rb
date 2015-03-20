require 'spec_helper'

describe 'httpd_module_test::default' do
  cached(:centos_58_module_22) do
    ChefSpec::ServerRunner.new(
      step_into: 'httpd_module',
      platform: 'centos',
      version: '5.8'
      ) do |node|
      node.set['httpd']['version'] = '2.2'
    end.converge('httpd_module_test::default')
  end

  cached(:auth_basic_load_content) do
    'LoadModule auth_basic_module /usr/lib64/httpd/modules/mod_auth_basic.so'
  end

  cached(:auth_kerb_load_content) do
    'LoadModule auth_kerb_module /usr/lib64/httpd/modules/mod_auth_kerb.so'
  end

  # test recipe compilation
  context 'when compiling the recipe' do
    it 'creates httpd_module[auth_basic]' do
      expect(centos_58_module_22).to create_httpd_module('auth_basic')
    end

    it 'creates httpd_module[auth_kerb]' do
      expect(centos_58_module_22).to create_httpd_module('auth_kerb')
    end
  end

  context 'when stepping into httpd_module' do
    it 'installs package[auth_basic :create httpd]' do
      expect(centos_58_module_22).to install_package('auth_basic :create httpd')
        .with(
          package_name: 'httpd'
        )
    end

    it 'create directory[auth_basic :create /etc/httpd-default/conf.d]' do
      expect(centos_58_module_22).to create_directory('auth_basic :create /etc/httpd-default/conf.d')
        .with(
          owner: 'root',
          group: 'root',
          recursive: true
        )
    end

    # auth_basic
    it 'create template[auth_basic :create /etc/httpd-default/conf.d/auth_basic.load]' do
      expect(centos_58_module_22).to create_template('auth_basic :create /etc/httpd-default/conf.d/auth_basic.load')
        .with(
          owner: 'root',
          group: 'root',
          source: 'module_load.erb',
          mode: '0644'
        )
    end

    it 'renders file[auth_basic :create /etc/httpd-default/conf.d/auth_basic.load]' do
      expect(centos_58_module_22).to render_file('auth_basic :create /etc/httpd-default/conf.d/auth_basic.load')
        .with_content(
          auth_basic_load_content
        )
    end

    # auth_kerb
    it 'installs package[auth_kerb :create mod_auth_kerb]' do
      expect(centos_58_module_22).to install_package('auth_kerb :create mod_auth_kerb')
        .with(
          package_name: 'mod_auth_kerb'
        )
    end

    it 'deletes file[auth_kerb :create /etc/httpd-default/conf.d/auth_kerb.conf]' do
      expect(centos_58_module_22).to_not delete_file('auth_kerb :create /etc/httpd-default/conf.d/auth_kerb.conf')
        .with(
          path: '/etc/httpd-default/conf.d/auth_kerb.conf'
        )
    end

    it 'create directory[auth_kerb :create /etc/httpd-default/conf.d]' do
      expect(centos_58_module_22).to create_directory('auth_kerb :create /etc/httpd-default/conf.d')
        .with(
          owner: 'root',
          group: 'root',
          recursive: true
        )
    end

    it 'create template[auth_kerb :create /etc/httpd-default/conf.d/auth_kerb.load]' do
      expect(centos_58_module_22).to create_template('auth_kerb :create /etc/httpd-default/conf.d/auth_kerb.load')
        .with(
          owner: 'root',
          group: 'root',
          source: 'module_load.erb',
          mode: '0644'
        )
    end

    it 'renders file[auth_kerb :create /etc/httpd-default/conf.d/auth_kerb.load]' do
      expect(centos_58_module_22).to render_file('auth_kerb :create /etc/httpd-default/conf.d/auth_kerb.load')
        .with_content(
          auth_kerb_load_content
        )
    end
  end
end
