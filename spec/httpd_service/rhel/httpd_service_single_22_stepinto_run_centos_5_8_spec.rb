require 'spec_helper'

describe 'httpd_service::single on rhel-5.8' do
  let(:httpd_service_single_22_run_centos_5_8) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'centos',
      :version => '5.8'
      ).converge('httpd_service::single')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[default]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_httpd_service('default').with(
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
        :version => '2.2',
        :mpm => 'worker',
        :startservers => '2',
        :minspareservers => nil,
        :maxspareservers => nil,
        :maxclients => '150',
        :maxrequestsperchild => '0',
        :minsparethreads => '25',
        :maxsparethreads => '75',
        :threadlimit => '64',
        :threadsperchild => '25',
        :maxrequestworkers => nil,
        :maxconnectionsperchild => nil
        )
    end
  end

  context 'when stepping into httpd_service' do
    it 'installs package[httpd]' do
      expect(httpd_service_single_22_run_centos_5_8).to install_package('default create httpd').with(
        :package_name => 'httpd'
        )
    end

    it 'deletes file[/etc/httpd/conf.d/README]' do
      expect(httpd_service_single_22_run_centos_5_8).to_not delete_file('default create /etc/httpd/conf.d/README').with(
        :path => '/etc/httpd/conf.d/README'
        )
    end

    it 'deletes file[/etc/httpd/conf.d/welcome.conf]' do
      expect(httpd_service_single_22_run_centos_5_8).to_not delete_file('default create /etc/httpd/conf.d/welcome.conf').with(
        :path => '/etc/httpd/conf.d/welcome.conf'
        )
    end

    it 'deletes file[/etc/httpd/conf.d/proxy_ajp.conf]' do
      expect(httpd_service_single_22_run_centos_5_8).to_not delete_file('default create /etc/httpd/conf.d/proxy_ajp.conf').with(
        :path => '/etc/httpd/conf.d/proxy_ajp.conf'
        )
    end

    it 'installs package[net-tools]' do
      expect(httpd_service_single_22_run_centos_5_8).to install_package('default create net-tools').with(
        :package_name => 'net-tools'
        )
    end

    it 'creates httpd_module[default create log_config]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_httpd_module('default create log_config').with(
        :module_name => 'log_config'
        )
    end

    it 'creates httpd_module[default create logio]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_httpd_module('default create logio').with(
        :module_name => 'logio'
        )
    end

    it 'creates link[default create /usr/sbin/httpd]' do
      expect(httpd_service_single_22_run_centos_5_8).to_not create_link('default create /usr/sbin/httpd').with(
        :target_file => '/usr/sbin/httpd',
        :to => '/usr/sbin/httpd'
        )
    end

    it 'creates link[default create /usr/sbin/httpd.worker]' do
      expect(httpd_service_single_22_run_centos_5_8).to_not create_link('default create /usr/sbin/httpd.worker').with(
        :target_file => '/usr/sbin/httpd.worker',
        :to => '/usr/sbin/httpd.worker'
        )
    end

    it 'creates link[default create /usr/sbin/httpd.event]' do
      expect(httpd_service_single_22_run_centos_5_8).to_not create_link('default create /usr/sbin/httpd.event').with(
        :target_file => '/usr/sbin/httpd.event',
        :to => '/usr/sbin/httpd.event'
        )
    end

    it 'creates httpd_config[default create mpm_worker]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_httpd_config('default create mpm_worker').with(
        :config_name => 'mpm_worker',
        :instance => 'default',
        :source => 'mpm.conf.erb',
        :cookbook => 'httpd'
        )
    end

    it 'creates directory[default create /etc/httpd]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_directory('default create /etc/httpd').with(
        :path => '/etc/httpd',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[default create /etc/httpd/conf]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_directory('default create /etc/httpd/conf').with(
        :path => '/etc/httpd/conf',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[default create /etc/httpd/conf.d]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_directory('default create /etc/httpd/conf.d').with(
        :path => '/etc/httpd/conf.d',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[default create /usr/lib64/httpd/modules]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_directory('default create /usr/lib64/httpd/modules').with(
        :path => '/usr/lib64/httpd/modules',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[default create /var/log/httpd]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_directory('default create /var/log/httpd').with(
        :path => '/var/log/httpd',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates link[default create /etc/httpd/logs]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_link('default create /etc/httpd/logs').with(
        :target_file => '/etc/httpd/logs',
        :to => '../../var/log/httpd'
        )
    end

    it 'creates link[default create /etc/httpd/modules]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_link('default create /etc/httpd/modules').with(
        :target_file => '/etc/httpd/modules',
        :to => '../../usr/lib64/httpd/modules'
        )
    end

    it 'creates link[default create /etc/httpd/run]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_link('default create /etc/httpd/run').with(
        :target_file => '/etc/httpd/run',
        :to => '../../var/run'
        )
    end

    it 'creates template[default create /etc/httpd/conf/magic]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_template('default create /etc/httpd/conf/magic').with(
        :path => '/etc/httpd/conf/magic',
        :source => 'magic.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'creates template[default create /etc/httpd/conf/httpd.conf]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_template('default create /etc/httpd/conf/httpd.conf').with(
        :path => '/etc/httpd/conf/httpd.conf',
        :source => 'httpd.conf.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'creates template[default create /etc/rc.d/init.d/httpd]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_template('default create /etc/init.d/httpd').with(
        :path => '/etc/init.d/httpd',
        :source => '2.2/sysvinit/el-5/httpd.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0755',
        :cookbook => 'httpd'
        )
    end

    it 'creates template[default create /etc/sysconfig/httpd]' do
      expect(httpd_service_single_22_run_centos_5_8).to create_template('default create /etc/sysconfig/httpd').with(
        :path => '/etc/sysconfig/httpd',
        :source => 'rhel/sysconfig/httpd-2.2.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'manage service[default create httpd]' do
      expect(httpd_service_single_22_run_centos_5_8).to start_service('default create httpd').with(
        :provider => Chef::Provider::Service::Init::Redhat
        )
      expect(httpd_service_single_22_run_centos_5_8).to enable_service('default create httpd').with(
        :provider => Chef::Provider::Service::Init::Redhat
        )
    end
  end
end
