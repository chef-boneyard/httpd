require 'spec_helper'

describe 'httpd_service_test::multi' do
  before do
    allow(Chef::Platform::ServiceHelpers).to receive(:service_resource_providers).and_return(
      [:redhat]
    )
  end

  cached(:centos_5_service_22_multi) do
    ChefSpec::ServerRunner.new(
      step_into: 'httpd_service',
      platform: 'centos',
      version: '5.11'
    ) do |node|
      node.normal['httpd']['contact'] = 'bob@computers.biz'
      node.normal['httpd']['version'] = '2.2'
      node.normal['httpd']['keepalive'] = false
      node.normal['httpd']['maxkeepaliverequests'] = '5678'
      node.normal['httpd']['keepalivetimeout'] = '8765'
      node.normal['httpd']['listen_addresses'] = ['0.0.0.0']
      node.normal['httpd']['listen_ports'] = %w(81 444)
      node.normal['httpd']['log_level'] = 'warn'
      node.normal['httpd']['run_user'] = 'bob'
      node.normal['httpd']['run_group'] = 'bob'
      node.normal['httpd']['timeout'] = '1234'
      node.normal['httpd']['mpm'] = 'prefork'
    end.converge('httpd_service_test::multi')
  end

  context 'when compiling the test recipe' do
    it 'creates group[alice]' do
      expect(centos_5_service_22_multi).to create_group('alice')
    end

    it 'creates user[alice]' do
      expect(centos_5_service_22_multi).to create_user('alice')
    end

    it 'creates group[bob]' do
      expect(centos_5_service_22_multi).to create_group('bob')
    end

    it 'creates user[bob]' do
      expect(centos_5_service_22_multi).to create_user('bob')
    end

    it 'deletes httpd_service[default]' do
      expect(centos_5_service_22_multi).to delete_httpd_service('default')
    end

    # it 'creates httpd_service[instance-1]' do
    #   expect(centos_5_service_22_multi).to create_httpd_service('instance-1')
    #     .with(
    #       contact: 'hal@computers.biz',
    #       hostname_lookups: 'off',
    #       keepalive: false,
    #       keepalivetimeout: '0',
    #       listen_addresses: ['0.0.0.0'],
    #       listen_ports: %w(8080 4343),
    #       log_level: 'warn',
    #       maxkeepaliverequests: '2001',
    #       timeout: '4321'
    #     )
    # end

    it 'creates httpd_service[instance-1]' do
      expect(centos_5_service_22_multi).to create_httpd_service('instance-2')
        .with(
          contact: 'bob@computers.biz',
          hostname_lookups: 'off',
          keepalive: false,
          keepalivetimeout: '8765',
          listen_addresses: ['0.0.0.0'],
          listen_ports: %w(81 444),
          log_level: 'warn',
          maxkeepaliverequests: '5678',
          timeout: '1234'
        )
    end
  end

  context 'when stepping into httpd_service' do
    # deletes httpd_service[default]
    it 'manages service[httpd-default]' do
      expect(centos_5_service_22_multi).to stop_service('httpd-default')
        .with(
          provider: Chef::Provider::Service::Init::Redhat
        )
      expect(centos_5_service_22_multi).to disable_service('httpd-default')
        .with(
          provider: Chef::Provider::Service::Init::Redhat
        )
    end

    it 'deletes link[/usr/sbin/httpd-default]' do
      expect(centos_5_service_22_multi).to delete_link('/usr/sbin/httpd-default')
        .with(
          target_file: '/usr/sbin/httpd-default',
          to: '/usr/sbin/httpd'
        )
    end

    it 'deletes link[/usr/sbin/httpd-default.worker]' do
      expect(centos_5_service_22_multi).to delete_link('/usr/sbin/httpd-default.worker')
        .with(
          target_file: '/usr/sbin/httpd-default.worker',
          to: '/usr/sbin/httpd.worker'
        )
    end

    it 'deletes link[/usr/sbin/httpd-default.event]' do
      expect(centos_5_service_22_multi).to delete_link('/usr/sbin/httpd-default.event')
        .with(
          target_file: '/usr/sbin/httpd-default.event',
          to: '/usr/sbin/httpd.event'
        )
    end

    it 'deletes directory[/etc/httpd-default]' do
      expect(centos_5_service_22_multi).to delete_directory('/etc/httpd-default')
        .with(
          path: '/etc/httpd-default'
        )
    end

    it 'deletes directory[/var/log/httpd-default]' do
      expect(centos_5_service_22_multi).to delete_directory('/var/log/httpd-default')
        .with(
          path: '/var/log/httpd-default'
        )
    end

    it 'deletes link[/etc/httpd-default/run]' do
      expect(centos_5_service_22_multi).to delete_link('/etc/httpd-default/run')
        .with(
          target_file: '/etc/httpd-default/run'
        )
    end

    # create httpd_service[instance-1]
    it 'installs package[httpd]' do
      expect(centos_5_service_22_multi).to install_package('httpd')
        .with(
          package_name: 'httpd'
        )
    end

    # it 'manage service[httpd-instance-1]' do
    #   expect(centos_5_service_22_multi).to stop_service('httpd')
    #     .with(
    #       provider: Chef::Provider::Service::Init::Redhat
    #     )
    #   expect(centos_5_service_22_multi).to disable_service('httpd')
    #     .with(
    #       provider: Chef::Provider::Service::Init::Redhat
    #     )
    # end

    # it 'installs httpd_module[log_config]' do
    #   expect(centos_5_service_22_multi).to create_httpd_module('log_config')
    #     .with(
    #       module_name: 'log_config',
    #       httpd_version: '2.2',
    #       instance: 'instance-1'
    #     )
    # end

    # it 'installs httpd_module[logio]' do
    #   expect(centos_5_service_22_multi).to create_httpd_module('logio')
    #     .with(
    #       module_name: 'logio',
    #       httpd_version: '2.2',
    #       instance: 'instance-1'
    #     )
    # end

    # it 'creates link[/usr/sbin/httpd-instance-1]' do
    #   expect(centos_5_service_22_multi).to create_link('/usr/sbin/httpd-instance-1')
    #     .with(
    #       target_file: '/usr/sbin/httpd-instance-1',
    #       to: '/usr/sbin/httpd'
    #     )
    # end

    # it 'creates link[/usr/sbin/httpd-instance-1.worker]' do
    #   expect(centos_5_service_22_multi).to create_link('/usr/sbin/httpd-instance-1.worker')
    #     .with(
    #       target_file: '/usr/sbin/httpd-instance-1.worker',
    #       to: '/usr/sbin/httpd.worker'
    #     )
    # end

    # it 'creates link[/usr/sbin/httpd-instance-1.event]' do
    #   expect(centos_5_service_22_multi).to create_link('/usr/sbin/httpd-instance-1.event')
    #     .with(
    #       target_file: '/usr/sbin/httpd-instance-1.event',
    #       to: '/usr/sbin/httpd.event'
    #     )
    # end

    # it 'creates httpd_config[mpm_prefork]' do
    #   expect(centos_5_service_22_multi).to create_httpd_config('mpm_prefork')
    #     .with(
    #       config_name: 'mpm_prefork',
    #       instance: 'instance-1',
    #       source: 'mpm.conf.erb',
    #       cookbook: 'httpd'
    #     )
    # end

    # it 'creates directory[/etc/httpd-instance-1]' do
    #   expect(centos_5_service_22_multi).to create_directory('/etc/httpd-instance-1')
    #     .with(
    #       path: '/etc/httpd-instance-1',
    #       user: 'root',
    #       group: 'root',
    #       mode: '0755',
    #       recursive: true
    #     )
    # end

    # it 'creates directory[/etc/httpd-instance-1/conf]' do
    #   expect(centos_5_service_22_multi).to create_directory('/etc/httpd-instance-1/conf')
    #     .with(
    #       path: '/etc/httpd-instance-1/conf',
    #       user: 'root',
    #       group: 'root',
    #       mode: '0755',
    #       recursive: true
    #     )
    # end

    # it 'creates directory[/etc/httpd-instance-1/conf.d]' do
    #   expect(centos_5_service_22_multi).to create_directory('/etc/httpd-instance-1/conf.d')
    #     .with(
    #       path: '/etc/httpd-instance-1/conf.d',
    #       user: 'root',
    #       group: 'root',
    #       mode: '0755',
    #       recursive: true
    #     )
    # end

    # it 'creates directory[/usr/lib64/httpd/modules]' do
    #   expect(centos_5_service_22_multi).to create_directory('/usr/lib64/httpd/modules')
    #     .with(
    #       path: '/usr/lib64/httpd/modules',
    #       user: 'root',
    #       group: 'root',
    #       mode: '0755',
    #       recursive: true
    #     )
    # end

    # it 'creates directory[/var/log/httpd-instance-1]' do
    #   expect(centos_5_service_22_multi).to create_directory('/var/log/httpd-instance-1')
    #     .with(
    #       path: '/var/log/httpd-instance-1',
    #       user: 'root',
    #       group: 'root',
    #       mode: '0755',
    #       recursive: true
    #     )
    # end

    # it 'creates link[/etc/httpd-instance-1/logs]' do
    #   expect(centos_5_service_22_multi).to create_link('/etc/httpd-instance-1/logs')
    #     .with(
    #       target_file: '/etc/httpd-instance-1/logs',
    #       to: '../../var/log/httpd-instance-1'
    #     )
    # end

    # it 'creates link[/etc/httpd-instance-1/modules]' do
    #   expect(centos_5_service_22_multi).to create_link('/etc/httpd-instance-1/modules')
    #     .with(
    #       target_file: '/etc/httpd-instance-1/modules',
    #       to: '../../usr/lib64/httpd/modules'
    #     )
    # end

    # it 'creates link[/etc/httpd-instance-1/run]' do
    #   expect(centos_5_service_22_multi).to create_link('/etc/httpd-instance-1/run')
    #     .with(
    #       target_file: '/etc/httpd-instance-1/run',
    #       to: '../../var/run'
    #     )
    # end

    # it 'creates template[/etc/httpd-instance-1/conf/mime.types]' do
    #   expect(centos_5_service_22_multi).to create_template('/etc/httpd-instance-1/conf/mime.types')
    #     .with(
    #       path: '/etc/httpd-instance-1/conf/mime.types',
    #       source: 'magic.erb',
    #       owner: 'root',
    #       group: 'root',
    #       mode: '0644',
    #       cookbook: 'httpd'
    #     )
    # end

    # it 'creates template[/etc/httpd-instance-1/conf/httpd.conf]' do
    #   expect(centos_5_service_22_multi).to create_template('/etc/httpd-instance-1/conf/httpd.conf')
    #     .with(
    #       path: '/etc/httpd-instance-1/conf/httpd.conf',
    #       source: 'httpd.conf.erb',
    #       owner: 'root',
    #       group: 'root',
    #       mode: '0644',
    #       cookbook: 'httpd'
    #     )
    # end

    # # sysvinit
    # it 'creates template[/etc/init.d/httpd-instance-1]' do
    #   expect(centos_5_service_22_multi).to create_template('/etc/init.d/httpd-instance-1')
    #     .with(
    #       path: '/etc/init.d/httpd-instance-1',
    #       source: '2.2/sysvinit/el-5/httpd.erb',
    #       owner: 'root',
    #       group: 'root',
    #       mode: '0755',
    #       cookbook: 'httpd'
    #     )
    # end

    # it 'creates template[/etc/sysconfig/httpd-instance-1]' do
    #   expect(centos_5_service_22_multi).to create_template('/etc/sysconfig/httpd-instance-1')
    #     .with(
    #       path: '/etc/sysconfig/httpd-instance-1',
    #       source: 'rhel/sysconfig/httpd-2.2.erb',
    #       owner: 'root',
    #       group: 'root',
    #       mode: '0644',
    #       cookbook: 'httpd'
    #     )
    # end

    # %w(
    #   alias autoindex dir
    #   env mime negotiation
    #   setenvif status auth_basic
    #   deflate authz_default
    #   authz_user authz_groupfile
    #   authn_file authz_host
    #   reqtimeout
    # ).each do |mod|
    #   it "steps into httpd_service[instance-1] and creates httpd_module[#{mod}]" do
    #     expect(centos_5_service_22_multi).to create_httpd_module("#{mod}")
    #       .with(
    #         module_name: mod,
    #         instance: 'instance-1',
    #         httpd_version: '2.2'
    #       )
    #   end
    # end

    # it 'manages service[httpd-instance-1]' do
    #   expect(centos_5_service_22_multi).to start_service('httpd-instance-1')
    #     .with(
    #       service_name: 'httpd-instance-1',
    #       provider: Chef::Provider::Service::Init::Redhat
    #     )
    #   expect(centos_5_service_22_multi).to enable_service('httpd-instance-1')
    #     .with(
    #       service_name: 'httpd-instance-1',
    #       provider: Chef::Provider::Service::Init::Redhat
    #     )
    # end

    # create httpd_service[instance-2]
    it 'installs package[httpd]' do
      expect(centos_5_service_22_multi).to install_package('httpd')
        .with(
          package_name: 'httpd'
        )
    end

    it 'manage service[httpd-instance-2]' do
      expect(centos_5_service_22_multi).to stop_service('httpd')
        .with(
          provider: Chef::Provider::Service::Init::Redhat
        )
      expect(centos_5_service_22_multi).to disable_service('httpd')
        .with(
          provider: Chef::Provider::Service::Init::Redhat
        )
    end

    it 'installs httpd_module[log_config]' do
      expect(centos_5_service_22_multi).to create_httpd_module('log_config')
        .with(
          module_name: 'log_config',
          httpd_version: '2.2',
          instance: 'instance-2'
        )
    end

    it 'installs httpd_module[logio]' do
      expect(centos_5_service_22_multi).to create_httpd_module('logio')
        .with(
          module_name: 'logio',
          httpd_version: '2.2',
          instance: 'instance-2'
        )
    end

    it 'creates link[/usr/sbin/httpd-instance-2]' do
      expect(centos_5_service_22_multi).to create_link('/usr/sbin/httpd-instance-2')
        .with(
          target_file: '/usr/sbin/httpd-instance-2',
          to: '/usr/sbin/httpd'
        )
    end

    it 'creates link[/usr/sbin/httpd-instance-2.worker]' do
      expect(centos_5_service_22_multi).to create_link('/usr/sbin/httpd-instance-2.worker')
        .with(
          target_file: '/usr/sbin/httpd-instance-2.worker',
          to: '/usr/sbin/httpd.worker'
        )
    end

    it 'creates link[/usr/sbin/httpd-instance-2.event]' do
      expect(centos_5_service_22_multi).to create_link('/usr/sbin/httpd-instance-2.event')
        .with(
          target_file: '/usr/sbin/httpd-instance-2.event',
          to: '/usr/sbin/httpd.event'
        )
    end

    it 'creates httpd_config[mpm_prefork]' do
      expect(centos_5_service_22_multi).to create_httpd_config('mpm_prefork')
        .with(
          config_name: 'mpm_prefork',
          instance: 'instance-2',
          source: 'mpm.conf.erb',
          cookbook: 'httpd'
        )
    end

    it 'creates directory[/etc/httpd-instance-2]' do
      expect(centos_5_service_22_multi).to create_directory('/etc/httpd-instance-2')
        .with(
          path: '/etc/httpd-instance-2',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates directory[/etc/httpd-instance-2/conf]' do
      expect(centos_5_service_22_multi).to create_directory('/etc/httpd-instance-2/conf')
        .with(
          path: '/etc/httpd-instance-2/conf',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates directory[/etc/httpd-instance-2/conf.d]' do
      expect(centos_5_service_22_multi).to create_directory('/etc/httpd-instance-2/conf.d')
        .with(
          path: '/etc/httpd-instance-2/conf.d',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates directory[/usr/lib64/httpd/modules]' do
      expect(centos_5_service_22_multi).to create_directory('/usr/lib64/httpd/modules')
        .with(
          path: '/usr/lib64/httpd/modules',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates directory[/var/log/httpd-instance-2]' do
      expect(centos_5_service_22_multi).to create_directory('/var/log/httpd-instance-2')
        .with(
          path: '/var/log/httpd-instance-2',
          user: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
    end

    it 'creates link[/etc/httpd-instance-2/logs]' do
      expect(centos_5_service_22_multi).to create_link('/etc/httpd-instance-2/logs')
        .with(
          target_file: '/etc/httpd-instance-2/logs',
          to: '../../var/log/httpd-instance-2'
        )
    end

    it 'creates link[/etc/httpd-instance-2/modules]' do
      expect(centos_5_service_22_multi).to create_link('/etc/httpd-instance-2/modules')
        .with(
          target_file: '/etc/httpd-instance-2/modules',
          to: '../../usr/lib64/httpd/modules'
        )
    end

    it 'creates link[/etc/httpd-instance-2/run]' do
      expect(centos_5_service_22_multi).to create_link('/etc/httpd-instance-2/run')
        .with(
          target_file: '/etc/httpd-instance-2/run',
          to: '../../var/run'
        )
    end

    it 'creates template[/etc/httpd-instance-2/conf/mime.types]' do
      expect(centos_5_service_22_multi).to create_template('/etc/httpd-instance-2/conf/mime.types')
        .with(
          path: '/etc/httpd-instance-2/conf/mime.types',
          source: 'magic.erb',
          owner: 'root',
          group: 'root',
          mode: '0644',
          cookbook: 'httpd'
        )
    end

    it 'creates template[/etc/httpd-instance-2/conf/httpd.conf]' do
      expect(centos_5_service_22_multi).to create_template('/etc/httpd-instance-2/conf/httpd.conf')
        .with(
          path: '/etc/httpd-instance-2/conf/httpd.conf',
          source: 'httpd.conf.erb',
          owner: 'root',
          group: 'root',
          mode: '0644',
          cookbook: 'httpd'
        )
    end

    # sysvinit
    it 'creates template[/etc/init.d/httpd-instance-2]' do
      expect(centos_5_service_22_multi).to create_template('/etc/init.d/httpd-instance-2')
        .with(
          path: '/etc/init.d/httpd-instance-2',
          source: '2.2/sysvinit/el-5/httpd.erb',
          owner: 'root',
          group: 'root',
          mode: '0755',
          cookbook: 'httpd'
        )
    end

    it 'creates template[/etc/sysconfig/httpd-instance-2]' do
      expect(centos_5_service_22_multi).to create_template('/etc/sysconfig/httpd-instance-2')
        .with(
          path: '/etc/sysconfig/httpd-instance-2',
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
      it "steps into httpd_service[instance-2] and creates httpd_module[#{mod}]" do
        expect(centos_5_service_22_multi).to create_httpd_module(mod)
          .with(
            module_name: mod,
            instance: 'instance-2',
            httpd_version: '2.2'
          )
      end
    end

    it 'manages service[httpd-instance-2]' do
      expect(centos_5_service_22_multi).to start_service('httpd-instance-2')
        .with(
          service_name: 'httpd-instance-2',
          provider: Chef::Provider::Service::Init::Redhat
        )
      expect(centos_5_service_22_multi).to enable_service('httpd-instance-2')
        .with(
          service_name: 'httpd-instance-2',
          provider: Chef::Provider::Service::Init::Redhat
        )
    end
  end
end
