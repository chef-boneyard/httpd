require 'spec_helper'

describe 'httpd_service::multi on rhel-6.4' do
  let(:httpd_service_multi_22_run_centos_6_4) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'centos',
      :version => '6.4'
      ) do |node|
      node.set['httpd']['contact'] = 'bob@computers.biz'
      node.set['httpd']['version'] = '2.2'
      node.set['httpd']['keepalive'] = false
      node.set['httpd']['keepaliverequests'] = '5678'
      node.set['httpd']['keepalivetimeout'] = '8765'
      node.set['httpd']['listen_ports'] = %w(81 444)
      node.set['httpd']['log_level'] = 'warn'
      node.set['httpd']['run_user'] = 'bob'
      node.set['httpd']['run_group'] = 'bob'
      node.set['httpd']['timeout'] = '1234'
      node.set['httpd']['mpm'] = 'prefork'
    end.converge('httpd_service::multi')
  end

  context 'when compiling the test recipe' do
    it 'creates group[alice]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_group('alice')
    end

    it 'creates user[alice]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_user('alice')
    end

    it 'creates group[bob]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_group('bob')
    end

    it 'creates user[bob]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_user('bob')
    end

    it 'deletes httpd_service[delete]' do
      expect(httpd_service_multi_22_run_centos_6_4).to delete_httpd_service('default')
    end

    it 'creates httpd_service[instance-1]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_httpd_service('instance-1').with(
        :contact => 'hal@computers.biz',
        :hostname_lookups => 'off',
        :keepalive => false,
        :keepaliverequests => '2001',
        :keepalivetimeout => '0',
        :listen_addresses => ['0.0.0.0'],
        :listen_ports => %w(8080 4343),
        :log_level => 'warn',
        :package_name => 'httpd',
        :run_user => 'alice',
        :run_group => 'alice',
        :timeout => '4321',
        :version => '2.2',
        :mpm => 'prefork',
        :startservers => '10',
        :minspareservers => '10',
        :maxspareservers => '20',
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

    it 'creates httpd_service[instance-1]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_httpd_service('instance-2').with(
        :contact => 'bob@computers.biz',
        :hostname_lookups => 'off',
        :keepalive => false,
        :keepaliverequests => '5678',
        :keepalivetimeout => '8765',
        :listen_addresses => ['0.0.0.0'],
        :listen_ports => %w(81 444),
        :log_level => 'warn',
        :package_name => 'httpd',
        :run_user => 'bob',
        :run_group => 'bob',
        :timeout => '1234',
        :version => '2.2',
        :mpm => 'prefork',
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

    it 'writes log[notify restart]' do
      expect(httpd_service_multi_22_run_centos_6_4).to write_log('notify restart')
    end

    it 'writes log[notify reload]' do
      expect(httpd_service_multi_22_run_centos_6_4).to write_log('notify reload')
    end
  end

  context 'when stepping into httpd_service' do
    # default
    it 'manages service[default create httpd]' do
      expect(httpd_service_multi_22_run_centos_6_4).to stop_service('default create httpd').with(
        :provider => Chef::Provider::Service::Init::Redhat
        )
      expect(httpd_service_multi_22_run_centos_6_4).to disable_service('default create httpd').with(
        :provider => Chef::Provider::Service::Init::Redhat
        )
    end

    it 'deletes link[default delete /usr/sbin/httpd]' do
      expect(httpd_service_multi_22_run_centos_6_4).to_not delete_link('default delete /usr/sbin/httpd').with(
        :target_file => '/usr/sbin/httpd',
        :to => '/usr/sbin/httpd'
        )
    end

    it 'deletes link[default delete /usr/sbin/httpd.worker]' do
      expect(httpd_service_multi_22_run_centos_6_4).to_not delete_link('default delete /usr/sbin/httpd.worker').with(
        :target_file => '/usr/sbin/httpd.worker',
        :to => '/usr/sbin/httpd'
        )
    end

    it 'deletes link[default delete /usr/sbin/httpd.event]' do
      expect(httpd_service_multi_22_run_centos_6_4).to_not delete_link('default delete /usr/sbin/httpd.event').with(
        :target_file => '/usr/sbin/httpd.event',
        :to => '/usr/sbin/httpd'
        )
    end

    it 'deletes directory[default delete /etc/httpd]' do
      expect(httpd_service_multi_22_run_centos_6_4).to delete_directory('default delete /etc/httpd').with(
        :path => '/etc/httpd'
        )
    end

    it 'deletes directory[default delete /var/log/httpd]' do
      expect(httpd_service_multi_22_run_centos_6_4).to delete_directory('default delete /var/log/httpd').with(
        :path => '/var/log/httpd'
        )
    end

    it 'default delete /var/run/httpd' do
      expect(httpd_service_multi_22_run_centos_6_4).to delete_directory('default delete /var/run/httpd').with(
        :path => '/var/run/httpd'
        )
    end

    it 'deletes link[default delete /etc/httpd/run]' do
      expect(httpd_service_multi_22_run_centos_6_4).to delete_link('default delete /etc/httpd/run').with(
        :target_file => '/etc/httpd/run'
        )
    end

    # instance-1
    it 'installs package[instance-1 create httpd]' do
      expect(httpd_service_multi_22_run_centos_6_4).to install_package('instance-1 create httpd').with(
        :package_name => 'httpd'
        )
    end

    it 'bash[instance-1 create remove_package_config]' do
      expect(httpd_service_multi_22_run_centos_6_4).to_not run_bash('instance-1 create remove_package_config').with(
        :user => 'root'
        )
    end

    it 'installs package[instance-1 create net-tools]' do
      expect(httpd_service_multi_22_run_centos_6_4).to install_package('instance-1 create net-tools').with(
        :package_name => 'net-tools'
        )
    end

    it 'installs httpd_module[instance-1 create log_config]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_httpd_module('instance-1 create log_config').with(
        :module_name => 'log_config',
        :httpd_version => '2.2',
        :instance => 'instance-1'
        )
    end

    it 'installs httpd_module[instance-1 create logio]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_httpd_module('instance-1 create logio').with(
        :module_name => 'logio',
        :httpd_version => '2.2',
        :instance => 'instance-1'
        )
    end

    it 'creates link[instance-1 create /usr/sbin/httpd-instance-1]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_link('instance-1 create /usr/sbin/httpd-instance-1').with(
        :target_file => '/usr/sbin/httpd-instance-1',
        :to => '/usr/sbin/httpd'
        )
    end

    it 'creates link[instance-1 create /usr/sbin/httpd-instance-1.worker]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_link('instance-1 create /usr/sbin/httpd-instance-1.worker').with(
        :target_file => '/usr/sbin/httpd-instance-1.worker',
        :to => '/usr/sbin/httpd.worker'
        )
    end

    it 'creates link[instance-1 create /usr/sbin/httpd-instance-1.event]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_link('instance-1 create /usr/sbin/httpd-instance-1.event').with(
        :target_file => '/usr/sbin/httpd-instance-1.event',
        :to => '/usr/sbin/httpd.event'
        )
    end

    it 'creates httpd_config[instance-1 create mpm_prefork]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_httpd_config('instance-1 create mpm_prefork').with(
        :config_name => 'mpm_prefork',
        :instance => 'instance-1',
        :source => 'mpm.conf.erb',
        :cookbook => 'httpd'
        )
    end

    it 'creates directory[instance-1 create /etc/httpd-instance-1]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_directory('instance-1 create /etc/httpd-instance-1').with(
        :path => '/etc/httpd-instance-1',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[instance-1 create /etc/httpd-instance-1/conf]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_directory('instance-1 create /etc/httpd-instance-1/conf').with(
        :path => '/etc/httpd-instance-1/conf',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[instance-1 create /etc/httpd-instance-1/conf.d]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_directory('instance-1 create /etc/httpd-instance-1/conf.d').with(
        :path => '/etc/httpd-instance-1/conf.d',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[instance-1 create /usr/lib64/httpd/modules]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_directory('instance-1 create /usr/lib64/httpd/modules').with(
        :path => '/usr/lib64/httpd/modules',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[instance-1 create /var/log/httpd-instance-1]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_directory('instance-1 create /var/log/httpd-instance-1').with(
        :path => '/var/log/httpd-instance-1',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates link[instance-1 create /etc/httpd-instance-1/logs]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_link('instance-1 create /etc/httpd-instance-1/logs').with(
        :target_file => '/etc/httpd-instance-1/logs',
        :to => '../../var/log/httpd-instance-1'
        )
    end

    it 'creates link[instance-1 create /etc/httpd-instance-1/modules]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_link('instance-1 create /etc/httpd-instance-1/modules').with(
        :target_file => '/etc/httpd-instance-1/modules',
        :to => '../../usr/lib64/httpd/modules'
        )
    end

    it 'creates link[instance-1 create /etc/httpd-instance-1/run]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_link('instance-1 create /etc/httpd-instance-1/run').with(
        :target_file => '/etc/httpd-instance-1/run',
        :to => '../../var/run/httpd-instance-1'
        )
    end

    it 'creates directory[instance-1 create /var/run/httpd-instance-1]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_directory('instance-1 create /var/run/httpd-instance-1').with(
        :path => '/var/run/httpd-instance-1'
        )
    end

    it 'creates template[instance-1 create /etc/httpd-instance-1/conf/magic]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_template('instance-1 create /etc/httpd-instance-1/conf/magic').with(
        :path => '/etc/httpd-instance-1/conf/magic',
        :source => 'magic.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'creates template[instance-1 create /etc/httpd-instance-1/conf/httpd.conf]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_template('instance-1 create /etc/httpd-instance-1/conf/httpd.conf').with(
        :path => '/etc/httpd-instance-1/conf/httpd.conf',
        :source => 'httpd.conf.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    # sysvinit
    it 'creates template[instance-1 create /etc/init.d/httpd-instance-1]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_template('instance-1 create /etc/init.d/httpd-instance-1').with(
        :path => '/etc/init.d/httpd-instance-1',
        :source => '2.2/sysvinit/el-6/httpd.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0755',
        :cookbook => 'httpd'
        )
    end

    it 'creates template[instance-1 create /etc/sysconfig/httpd-instance-1]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_template('instance-1 create /etc/sysconfig/httpd-instance-1').with(
        :path => '/etc/sysconfig/httpd-instance-1',
        :source => 'rhel/sysconfig/httpd-2.2.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'manages instance-1 create httpd-instance-1' do
      expect(httpd_service_multi_22_run_centos_6_4).to start_service('instance-1 create httpd-instance-1').with(
        :service_name => 'httpd-instance-1',
        :provider => Chef::Provider::Service::Init::Redhat
        )
      expect(httpd_service_multi_22_run_centos_6_4).to enable_service('instance-1 create httpd-instance-1').with(
        :service_name => 'httpd-instance-1',
        :provider => Chef::Provider::Service::Init::Redhat
        )
    end

    # instance-2
    it 'installs package[instance-2 create httpd]' do
      expect(httpd_service_multi_22_run_centos_6_4).to install_package('instance-2 create httpd').with(
        :package_name => 'httpd'
        )
    end

    it 'bash[instance-2 create remove_package_config]' do
      expect(httpd_service_multi_22_run_centos_6_4).to_not run_bash('instance-2 create remove_package_config').with(
        :user => 'root'
        )
    end

    it 'installs package[instance-2 create net-tools]' do
      expect(httpd_service_multi_22_run_centos_6_4).to install_package('instance-2 create net-tools').with(
        :package_name => 'net-tools'
        )
    end

    it 'installs httpd_module[instance-2 create log_config]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_httpd_module('instance-2 create log_config').with(
        :module_name => 'log_config',
        :httpd_version => '2.2',
        :instance => 'instance-2'
        )
    end

    it 'installs httpd_module[instance-2 create logio]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_httpd_module('instance-2 create logio').with(
        :module_name => 'logio',
        :httpd_version => '2.2',
        :instance => 'instance-2'
        )
    end

    it 'creates link[instance-2 create /usr/sbin/httpd-instance-2]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_link('instance-2 create /usr/sbin/httpd-instance-2').with(
        :target_file => '/usr/sbin/httpd-instance-2',
        :to => '/usr/sbin/httpd'
        )
    end

    it 'creates link[instance-2 create /usr/sbin/httpd-instance-2.worker]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_link('instance-2 create /usr/sbin/httpd-instance-2.worker').with(
        :target_file => '/usr/sbin/httpd-instance-2.worker',
        :to => '/usr/sbin/httpd.worker'
        )
    end

    it 'creates link[instance-2 create /usr/sbin/httpd-instance-2.event]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_link('instance-2 create /usr/sbin/httpd-instance-2.event').with(
        :target_file => '/usr/sbin/httpd-instance-2.event',
        :to => '/usr/sbin/httpd.event'
        )
    end

    it 'creates httpd_config[instance-2 create mpm_prefork]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_httpd_config('instance-2 create mpm_prefork').with(
        :config_name => 'mpm_prefork',
        :instance => 'instance-2',
        :source => 'mpm.conf.erb',
        :cookbook => 'httpd'
        )
    end

    it 'creates directory[instance-2 create /etc/httpd-instance-2]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_directory('instance-2 create /etc/httpd-instance-2').with(
        :path => '/etc/httpd-instance-2',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[instance-2 create /etc/httpd-instance-2/conf]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_directory('instance-2 create /etc/httpd-instance-2/conf').with(
        :path => '/etc/httpd-instance-2/conf',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[instance-2 create /etc/httpd-instance-2/conf.d]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_directory('instance-2 create /etc/httpd-instance-2/conf.d').with(
        :path => '/etc/httpd-instance-2/conf.d',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[instance-2 create /usr/lib64/httpd/modules]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_directory('instance-2 create /usr/lib64/httpd/modules').with(
        :path => '/usr/lib64/httpd/modules',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[instance-2 create /var/log/httpd-instance-2]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_directory('instance-2 create /var/log/httpd-instance-2').with(
        :path => '/var/log/httpd-instance-2',
        :user => 'root',
        :group => 'root',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates link[instance-2 create /etc/httpd-instance-2/logs]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_link('instance-2 create /etc/httpd-instance-2/logs').with(
        :target_file => '/etc/httpd-instance-2/logs',
        :to => '../../var/log/httpd-instance-2'
        )
    end

    it 'creates link[instance-2 create /etc/httpd-instance-2/modules]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_link('instance-2 create /etc/httpd-instance-2/modules').with(
        :target_file => '/etc/httpd-instance-2/modules',
        :to => '../../usr/lib64/httpd/modules'
        )
    end

    it 'creates link[instance-2 create /etc/httpd-instance-2/run]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_link('instance-2 create /etc/httpd-instance-2/run').with(
        :target_file => '/etc/httpd-instance-2/run',
        :to => '../../var/run/httpd-instance-2'
        )
    end

    it 'creates directory[instance-2 create /var/run/httpd-instance-2]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_directory('instance-2 create /var/run/httpd-instance-2').with(
        :path => '/var/run/httpd-instance-2'
        )
    end

    it 'creates template[instance-2 create /etc/httpd-instance-2/conf/magic]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_template('instance-2 create /etc/httpd-instance-2/conf/magic').with(
        :path => '/etc/httpd-instance-2/conf/magic',
        :source => 'magic.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'creates template[instance-2 create /etc/httpd-instance-2/conf/httpd.conf]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_template('instance-2 create /etc/httpd-instance-2/conf/httpd.conf').with(
        :path => '/etc/httpd-instance-2/conf/httpd.conf',
        :source => 'httpd.conf.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    # sysvinit
    it 'creates template[instance-2 create /etc/init.d/httpd-instance-2]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_template('instance-2 create /etc/init.d/httpd-instance-2').with(
        :path => '/etc/init.d/httpd-instance-2',
        :source => '2.2/sysvinit/el-6/httpd.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0755',
        :cookbook => 'httpd'
        )
    end

    it 'creates template[instance-2 create /etc/sysconfig/httpd-instance-2]' do
      expect(httpd_service_multi_22_run_centos_6_4).to create_template('instance-2 create /etc/sysconfig/httpd-instance-2').with(
        :path => '/etc/sysconfig/httpd-instance-2',
        :source => 'rhel/sysconfig/httpd-2.2.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'manages instance-2 create httpd-instance-2' do
      expect(httpd_service_multi_22_run_centos_6_4).to start_service('instance-2 create httpd-instance-2').with(
        :service_name => 'httpd-instance-2',
        :provider => Chef::Provider::Service::Init::Redhat
        )
      expect(httpd_service_multi_22_run_centos_6_4).to enable_service('instance-2 create httpd-instance-2').with(
        :service_name => 'httpd-instance-2',
        :provider => Chef::Provider::Service::Init::Redhat
        )
    end
  end
end
