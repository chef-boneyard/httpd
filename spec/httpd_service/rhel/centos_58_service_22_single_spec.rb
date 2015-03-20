require 'spec_helper'

describe 'httpd_service_test::single' do
  cached(:centos_58_service_22_single) do
    ChefSpec::ServerRunner.new(
      step_into: 'httpd_service',
      platform: 'centos',
      version: '5.8'
      ).converge('httpd_service_test::single')
  end

  context 'when compiling the recipe' do
    it 'creates httpd_service[default]' do
      expect(centos_58_service_22_single).to create_httpd_service('default')
        .with(
          contact: 'webmaster@localhost',
          hostname_lookups: 'off',
          keepalive: true,
          keepalivetimeout: '5',
          listen_addresses: ['0.0.0.0'],
          listen_ports: %w(80),
          log_level: 'warn',
          maxkeepaliverequests: '100',
          maxspareservers: nil,
          minspareservers: nil,
          timeout: '400'
        )
    end
  end

  context 'when stepping into httpd_service' do
    it 'installs package[default :create httpd]' do
      expect(centos_58_service_22_single).to install_package('default :create httpd')
        .with(
          package_name: 'httpd'
        )
    end

    it 'manage service[default :create httpd-default]' do
      expect(centos_58_service_22_single).to stop_service('default :create httpd')
        .with(
          provider: Chef::Provider::Service::Init::Redhat
        )
      expect(centos_58_service_22_single).to disable_service('default :create httpd')
        .with(
          provider: Chef::Provider::Service::Init::Redhat
        )
    end

    it 'installs package[default :create net-tools]' do
      expect(centos_58_service_22_single).to install_package('default :create net-tools')
        .with(
          package_name: 'net-tools'
        )
    end

    it 'creates httpd_module[default :create log_config]' do
      expect(centos_58_service_22_single).to create_httpd_module('default :create log_config')
        .with(
          module_name: 'log_config'
        )
    end

    it 'creates httpd_module[default :create logio]' do
      expect(centos_58_service_22_single).to create_httpd_module('default :create logio')
        .with(
          module_name: 'logio'
        )
    end

    it 'creates link[default :create /usr/sbin/httpd-default]' do
      expect(centos_58_service_22_single).to create_link('default :create /usr/sbin/httpd-default')
        .with(
          target_file: '/usr/sbin/httpd-default',
          to: '/usr/sbin/httpd'
        )
    end

    it 'creates link[default :create /usr/sbin/httpd-default.worker]' do
      expect(centos_58_service_22_single).to create_link('default :create /usr/sbin/httpd-default.worker')
        .with(
          target_file: '/usr/sbin/httpd-default.worker',
          to: '/usr/sbin/httpd.worker'
        )
    end

    it 'creates link[default :create /usr/sbin/httpd-default.event]' do
      expect(centos_58_service_22_single).to create_link('default :create /usr/sbin/httpd-default.event')
        .with(
          target_file: '/usr/sbin/httpd-default.event',
          to: '/usr/sbin/httpd.event'
        )
    end

    it 'creates httpd_config[default :create mpm_worker]' do
      expect(centos_58_service_22_single).to create_httpd_config('default :create mpm_worker')
        .with(
          config_name: 'mpm_worker',
          instance: 'default',
          source: 'mpm.conf.erb',
          cookbook: 'httpd'
        )
    end

    it 'creates directory[default :create /etc/httpd-default]' do
      expect(centos_58_service_22_single).to create_directory('default :create /etc/httpd-default')
        .with(
          path: '/etc/httpd-default',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates directory[default :create /etc/httpd-default/conf]' do
      expect(centos_58_service_22_single).to create_directory('default :create /etc/httpd-default/conf')
        .with(
          path: '/etc/httpd-default/conf',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates directory[default :create /etc/httpd-default/conf.d]' do
      expect(centos_58_service_22_single).to create_directory('default :create /etc/httpd-default/conf.d')
        .with(
          path: '/etc/httpd-default/conf.d',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates directory[default :create /usr/lib64/httpd/modules]' do
      expect(centos_58_service_22_single).to create_directory('default :create /usr/lib64/httpd/modules')
        .with(
          path: '/usr/lib64/httpd/modules',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates directory[default :create /var/log/httpd]' do
      expect(centos_58_service_22_single).to create_directory('default :create /var/log/httpd-default')
        .with(
          path: '/var/log/httpd-default',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates link[default :create /etc/httpd-default/logs]' do
      expect(centos_58_service_22_single).to create_link('default :create /etc/httpd-default/logs')
        .with(
          target_file: '/etc/httpd-default/logs',
          to: '../../var/log/httpd-default'
        )
    end

    it 'creates link[default :create /etc/httpd-default/modules]' do
      expect(centos_58_service_22_single).to create_link('default :create /etc/httpd-default/modules')
        .with(
          target_file: '/etc/httpd-default/modules',
          to: '../../usr/lib64/httpd/modules'
        )
    end

    it 'creates link[default :create /etc/httpd-default/run]' do
      expect(centos_58_service_22_single).to create_link('default :create /etc/httpd-default/run')
        .with(
          target_file: '/etc/httpd-default/run',
          to: '../../var/run'
        )
    end

    it 'creates template[default :create /etc/httpd-default/conf/mime.types]' do
      expect(centos_58_service_22_single).to create_template('default :create /etc/httpd-default/conf/mime.types')
        .with(
          path: '/etc/httpd-default/conf/mime.types',
          source: 'magic.erb',
          owner: 'root',
          group: 'root',
          mode: '0644',
          cookbook: 'httpd'
        )
    end

    it 'creates template[default :create /etc/httpd-default/conf/httpd.conf]' do
      expect(centos_58_service_22_single).to create_template('default :create /etc/httpd-default/conf/httpd.conf')
        .with(
          path: '/etc/httpd-default/conf/httpd.conf',
          source: 'httpd.conf.erb',
          owner: 'root',
          group: 'root',
          mode: '0644',
          cookbook: 'httpd'
        )
    end

    it 'creates template[default :create /etc/rc.d/init.d/httpd]' do
      expect(centos_58_service_22_single).to create_template('default :create /etc/init.d/httpd-default')
        .with(
          path: '/etc/init.d/httpd-default',
          source: '2.2/sysvinit/el-5/httpd.erb',
          owner: 'root',
          group: 'root',
          mode: '0755',
          cookbook: 'httpd'
        )
    end

    it 'creates template[default :create /etc/sysconfig/httpd-default]' do
      expect(centos_58_service_22_single).to create_template('default :create /etc/sysconfig/httpd-default')
        .with(
          path: '/etc/sysconfig/httpd-default',
          source: 'rhel/sysconfig/httpd-2.2.erb',
          owner: 'root',
          group: 'root',
          mode: '0644',
          cookbook: 'httpd'
        )
    end

    %w(
      alias autoindex dir
      env mime negotiation
      setenvif status auth_basic
      deflate authz_default
      authz_user authz_groupfile
      authn_file authz_host
      reqtimeout
    ).each do |mod|
      it "steps into httpd_service[default] and creates httpd_module[default :create #{mod}]" do
        expect(centos_58_service_22_single).to create_httpd_module("default :create #{mod}")
          .with(
            module_name: mod,
            instance: 'default',
            httpd_version: '2.2'
          )
      end
    end

    it 'manage service[default :create httpd-default]' do
      expect(centos_58_service_22_single).to start_service('default :create httpd-default')
        .with(
          provider: Chef::Provider::Service::Init::Redhat
        )
      expect(centos_58_service_22_single).to enable_service('default :create httpd-default')
        .with(
          provider: Chef::Provider::Service::Init::Redhat
        )
    end
  end
end
