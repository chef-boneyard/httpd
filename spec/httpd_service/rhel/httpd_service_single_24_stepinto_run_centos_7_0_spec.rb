require 'spec_helper'

describe 'httpd_service::single on rhel-7.0' do
  let(:httpd_service_single_24_run_centos_7_0) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'centos',
      :version => '7.0'
      ).converge('httpd_service::single')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[default]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_httpd_service('default').with(
        :contact => 'webmaster@localhost',
        :hostname_lookups => 'off',
        :keepalive => true,
        :keepaliverequests => '100',
        :keepalivetimeout => '5',
        :listen_addresses => ['0.0.0.0'],
        :listen_ports => %w(80 443),
        :log_level => 'warn',
        :package_name => 'httpd',
        :run_user => 'apache',
        :run_group => 'apache',
        :timeout => '400',
        :version => '2.4',
        :mpm => 'event',
        :startservers => '2',
        :minspareservers => nil,
        :maxspareservers => nil,
        :maxclients => nil,
        :maxrequestsperchild => nil,
        :minsparethreads => '25',
        :maxsparethreads => '75',
        :threadlimit => '64',
        :threadsperchild => '25',
        :maxrequestworkers => '150',
        :maxconnectionsperchild => '0'
        )
    end
  end

  context 'when stepping into httpd_service' do
    it 'installs package[httpd]' do
      expect(httpd_service_single_24_run_centos_7_0).to install_package('default create httpd').with(
        :package_name => 'httpd'
        )
    end

    it 'deletes file[/etc/httpd/conf.d/autoindex.conf]' do
      expect(httpd_service_single_24_run_centos_7_0).to_not delete_file('default create /etc/httpd/conf.d/autoindex.conf').with(
        :path => '/etc/httpd/conf.d/autoindex.conf'
        )
    end

    it 'deletes file[/etc/httpd/conf.d/README]' do
      expect(httpd_service_single_24_run_centos_7_0).to_not delete_file('default create /etc/httpd/conf.d/README').with(
        :path => '/etc/httpd/conf.d/README'
        )
    end

    it 'deletes file[/etc/httpd/conf.d/userdir.conf]' do
      expect(httpd_service_single_24_run_centos_7_0).to_not delete_file('default create /etc/httpd/conf.d/userdir.conf').with(
        :path => '/etc/httpd/conf.d/userdir.conf'
        )
    end

    it 'deletes file[/etc/httpd/conf.d/welcome.conf]' do
      expect(httpd_service_single_24_run_centos_7_0).to_not delete_file('default create /etc/httpd/conf.d/welcome.conf').with(
        :path => '/etc/httpd/conf.d/welcome.conf'
        )
    end

    it 'installs package[net-tools]' do
      expect(httpd_service_single_24_run_centos_7_0).to install_package('default create net-tools').with(
        :package_name => 'net-tools'
        )
    end

    it 'creates httpd_module[default create log_config]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_httpd_module('default create log_config').with(
        :module_name => 'log_config'
        )
    end

    it 'creates httpd_module[default create logio]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_httpd_module('default create logio').with(
        :module_name => 'logio'
        )
    end

    it 'creates httpd_module[default create unixd]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_httpd_module('default create unixd').with(
        :module_name => 'unixd'
        )
    end

    it 'creates httpd_module[default create version]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_httpd_module('default create version').with(
        :module_name => 'version'
        )
    end

    it 'creates httpd_module[default create watchdog]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_httpd_module('default create watchdog').with(
        :module_name => 'watchdog'
        )
    end

    it 'creates link[default create /usr/sbin/httpd]' do
      expect(httpd_service_single_24_run_centos_7_0).to_not create_link('default create /usr/sbin/httpd').with(
        :target_file => '/usr/sbin/httpd',
        :to => '/usr/sbin/httpd'
        )
    end

    it 'creates link[default create /usr/sbin/httpd.worker]' do
      expect(httpd_service_single_24_run_centos_7_0).to_not create_link('default create /usr/sbin/httpd.worker').with(
        :target_file => '/usr/sbin/httpd.worker',
        :to => '/usr/sbin/httpd.worker'
        )
    end

    it 'creates link[default create /usr/sbin/httpd.event]' do
      expect(httpd_service_single_24_run_centos_7_0).to_not create_link('default create /usr/sbin/httpd.event').with(
        :target_file => '/usr/sbin/httpd.event',
        :to => '/usr/sbin/httpd.event'
        )
    end

    it 'creates httpd_module[default create mpm_event]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_httpd_module('default create mpm_event').with(
        :module_name => 'mpm_event'
        )
    end

    it 'creates httpd_config[default create mpm_event]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_httpd_config('default create mpm_event').with(
        :config_name => 'mpm_event',
        :instance => 'default',
        :source => 'mpm.conf.erb',
        :cookbook => 'httpd'
        )
    end

    it 'creates directory[default create /etc/httpd]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_directory('default create /etc/httpd').with(
        :path => '/etc/httpd',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[default create /etc/httpd/conf]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_directory('default create /etc/httpd/conf').with(
        :path => '/etc/httpd/conf',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[default create /etc/httpd/conf.d]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_directory('default create /etc/httpd/conf.d').with(
        :path => '/etc/httpd/conf.d',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[default create /etc/httpd/conf.modules.d]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_directory('default create /etc/httpd/conf.modules.d').with(
        :path => '/etc/httpd/conf.modules.d',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[default create /usr/lib64/httpd/modules]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_directory('default create /usr/lib64/httpd/modules').with(
        :path => '/usr/lib64/httpd/modules',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[default create /var/log/httpd]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_directory('default create /var/log/httpd').with(
        :path => '/var/log/httpd',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates link[default create /etc/httpd/logs]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_link('default create /etc/httpd/logs').with(
        :target_file => '/etc/httpd/logs',
        :to => '../../var/log/httpd'
        )
    end

    it 'creates link[default create /etc/httpd/modules]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_link('default create /etc/httpd/modules').with(
        :target_file => '/etc/httpd/modules',
        :to => '../../usr/lib64/httpd/modules'
        )
    end

    it 'creates directory[default create /var/run/httpd]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_directory('default create /var/run/httpd').with(
        :path => '/var/run/httpd',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates link[default create /etc/httpd/run]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_link('default create /etc/httpd/run').with(
        :target_file => '/etc/httpd/run',
        :to => '../../var/run/httpd'
        )
    end

    it 'creates template[default create /etc/httpd/conf/magic]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_template('default create /etc/httpd/conf/magic').with(
        :path => '/etc/httpd/conf/magic',
        :source => 'magic.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'creates template[default create /etc/httpd/conf/httpd.conf]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_template('default create /etc/httpd/conf/httpd.conf').with(
        :path => '/etc/httpd/conf/httpd.conf',
        :source => 'httpd.conf.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'creates httpd_module[default create systemd]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_httpd_module('default create systemd').with(
        :module_name => 'systemd'
        )
    end

    it 'creates directory[default create /run/httpd]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_directory('default create /run/httpd').with(
        :path => '/run/httpd',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates template[default create /usr/lib/systemd/system/httpd.service]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_template('default create /usr/lib/systemd/system/httpd.service').with(
        :path => '/usr/lib/systemd/system/httpd.service',
        :user => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'creates directory[default create /usr/lib/systemd/system/httpd.service.d]' do
      expect(httpd_service_single_24_run_centos_7_0).to create_directory('default create /usr/lib/systemd/system/httpd.service.d').with(
        :path => '/usr/lib/systemd/system/httpd.service.d',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'manage service[default create httpd]' do
      expect(httpd_service_single_24_run_centos_7_0).to start_service('default create httpd').with(
        :provider => Chef::Provider::Service::Init::Systemd
        )
      expect(httpd_service_single_24_run_centos_7_0).to enable_service('default create httpd').with(
        :provider => Chef::Provider::Service::Init::Systemd
        )
    end
  end
end
