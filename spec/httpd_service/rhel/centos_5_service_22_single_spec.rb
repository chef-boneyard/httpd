require 'spec_helper'

describe 'httpd_service_test::single' do
  cached(:centos_5_service_22_single) do
    ChefSpec::ServerRunner.new(
      step_into: 'httpd_service',
      platform: 'centos',
      version: '5.11'
    ).converge('httpd_service_test::single')
  end

  before do
    allow(Chef::Platform::ServiceHelpers).to receive(:service_resource_providers).and_return(
      [:redhat]
    )
  end

  context 'when compiling the recipe' do
    it 'creates httpd_service[default]' do
      expect(centos_5_service_22_single).to create_httpd_service('default')
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
    it 'installs package[httpd]' do
      expect(centos_5_service_22_single).to install_package('httpd')
        .with(
          package_name: 'httpd'
        )
    end

    it 'manage service[httpd-default]' do
      expect(centos_5_service_22_single).to stop_service('httpd')
        .with(
          provider: Chef::Provider::Service::Init::Redhat
        )
      expect(centos_5_service_22_single).to disable_service('httpd')
        .with(
          provider: Chef::Provider::Service::Init::Redhat
        )
    end

    it 'creates httpd_module[log_config]' do
      expect(centos_5_service_22_single).to create_httpd_module('log_config')
        .with(
          module_name: 'log_config'
        )
    end

    it 'creates httpd_module[logio]' do
      expect(centos_5_service_22_single).to create_httpd_module('logio')
        .with(
          module_name: 'logio'
        )
    end

    it 'creates link[/usr/sbin/httpd-default]' do
      expect(centos_5_service_22_single).to create_link('/usr/sbin/httpd-default')
        .with(
          target_file: '/usr/sbin/httpd-default',
          to: '/usr/sbin/httpd'
        )
    end

    it 'creates link[/usr/sbin/httpd-default.worker]' do
      expect(centos_5_service_22_single).to create_link('/usr/sbin/httpd-default.worker')
        .with(
          target_file: '/usr/sbin/httpd-default.worker',
          to: '/usr/sbin/httpd.worker'
        )
    end

    it 'creates link[/usr/sbin/httpd-default.event]' do
      expect(centos_5_service_22_single).to create_link('/usr/sbin/httpd-default.event')
        .with(
          target_file: '/usr/sbin/httpd-default.event',
          to: '/usr/sbin/httpd.event'
        )
    end

    it 'creates httpd_config[mpm_worker]' do
      expect(centos_5_service_22_single).to create_httpd_config('mpm_worker')
        .with(
          config_name: 'mpm_worker',
          instance: 'default',
          source: 'mpm.conf.erb',
          cookbook: 'httpd'
        )
    end

    it 'creates directory[/etc/httpd-default]' do
      expect(centos_5_service_22_single).to create_directory('/etc/httpd-default')
        .with(
          path: '/etc/httpd-default',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates directory[/etc/httpd-default/conf]' do
      expect(centos_5_service_22_single).to create_directory('/etc/httpd-default/conf')
        .with(
          path: '/etc/httpd-default/conf',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates directory[/etc/httpd-default/conf.d]' do
      expect(centos_5_service_22_single).to create_directory('/etc/httpd-default/conf.d')
        .with(
          path: '/etc/httpd-default/conf.d',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates directory[/usr/lib64/httpd/modules]' do
      expect(centos_5_service_22_single).to create_directory('/usr/lib64/httpd/modules')
        .with(
          path: '/usr/lib64/httpd/modules',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates directory[/var/log/httpd]' do
      expect(centos_5_service_22_single).to create_directory('/var/log/httpd-default')
        .with(
          path: '/var/log/httpd-default',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates link[/etc/httpd-default/logs]' do
      expect(centos_5_service_22_single).to create_link('/etc/httpd-default/logs')
        .with(
          target_file: '/etc/httpd-default/logs',
          to: '../../var/log/httpd-default'
        )
    end

    it 'creates link[/etc/httpd-default/modules]' do
      expect(centos_5_service_22_single).to create_link('/etc/httpd-default/modules')
        .with(
          target_file: '/etc/httpd-default/modules',
          to: '../../usr/lib64/httpd/modules'
        )
    end

    it 'creates link[/etc/httpd-default/run]' do
      expect(centos_5_service_22_single).to create_link('/etc/httpd-default/run')
        .with(
          target_file: '/etc/httpd-default/run',
          to: '../../var/run'
        )
    end

    it 'creates template[/etc/httpd-default/conf/mime.types]' do
      expect(centos_5_service_22_single).to create_template('/etc/httpd-default/conf/mime.types')
        .with(
          path: '/etc/httpd-default/conf/mime.types',
          source: 'magic.erb',
          owner: 'root',
          group: 'root',
          mode: '0644',
          cookbook: 'httpd'
        )
    end

    it 'creates template[/etc/httpd-default/conf/httpd.conf]' do
      expect(centos_5_service_22_single).to create_template('/etc/httpd-default/conf/httpd.conf')
        .with(
          path: '/etc/httpd-default/conf/httpd.conf',
          source: 'httpd.conf.erb',
          owner: 'root',
          group: 'root',
          mode: '0644',
          cookbook: 'httpd'
        )
    end

    it 'creates template[/etc/rc.d/init.d/httpd]' do
      expect(centos_5_service_22_single).to create_template('/etc/init.d/httpd-default')
        .with(
          path: '/etc/init.d/httpd-default',
          source: '2.2/sysvinit/el-5/httpd.erb',
          owner: 'root',
          group: 'root',
          mode: '0755',
          cookbook: 'httpd'
        )
    end

    it 'creates template[/etc/sysconfig/httpd-default]' do
      expect(centos_5_service_22_single).to create_template('/etc/sysconfig/httpd-default')
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
      it "steps into httpd_service[default] and creates httpd_module[#{mod}]" do
        expect(centos_5_service_22_single).to create_httpd_module(mod)
          .with(
            module_name: mod,
            instance: 'default',
            httpd_version: '2.2'
          )
      end
    end

    it 'manage service[httpd-default]' do
      expect(centos_5_service_22_single).to start_service('httpd-default')
        .with(
          provider: Chef::Provider::Service::Init::Redhat
        )
      expect(centos_5_service_22_single).to enable_service('httpd-default')
        .with(
          provider: Chef::Provider::Service::Init::Redhat
        )
    end
  end
end
