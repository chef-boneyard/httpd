require 'spec_helper'

describe 'httpd_test_multi::server 2.2 on debian-7.2' do
  let(:debian_7_2_multi_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'debian',
      :version => '7.2'
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
    end.converge('httpd_test_multi::server')
  end

  before do
    stub_command('test -f /usr/sbin/a2enmod').and_return(true)
    stub_command('test -f /usr/sbin/a2enmod-instance-1').and_return(true)
    stub_command('test -f /usr/sbin/a2enmod-instance-2').and_return(true)
  end

  # top level recipe
  context 'when compiling the recipe' do

    it 'creates group alice' do
      expect(debian_7_2_multi_stepinto_run).to create_group('alice')
    end

    it 'creates user alice' do
      expect(debian_7_2_multi_stepinto_run).to create_user('alice').with(
        :gid => 'alice'
        )
    end

    it 'creates group bob' do
      expect(debian_7_2_multi_stepinto_run).to create_group('bob')
    end

    it 'creates user bob' do
      expect(debian_7_2_multi_stepinto_run).to create_user('bob').with(
        :gid => 'bob'
        )
    end

    it 'deletes httpd_service[default]' do
      expect(debian_7_2_multi_stepinto_run).to delete_httpd_service('default')
    end

    it 'creates httpd_service[instance-1]' do
      expect(debian_7_2_multi_stepinto_run).to create_httpd_service('instance-1').with(
        :contact => 'hal@computers.biz',
        :hostname_lookups => 'off',
        :keepalive => false,
        :keepaliverequests => '2001',
        :keepalivetimeout => '0',
        :listen_addresses => ['0.0.0.0'],
        :listen_ports => %w(8080 4343),
        :log_level => 'warn',
        :version => '2.2',
        :package_name => 'apache2',
        :run_user => 'alice',
        :run_group => 'alice',
        :timeout => '4321'
        )
    end

    it 'creates httpd_service[instance-2]' do
      expect(debian_7_2_multi_stepinto_run).to create_httpd_service('instance-2').with(
        :contact => 'bob@computers.biz',
        :hostname_lookups => 'off',
        :keepalive => false,
        :keepaliverequests => '5678',
        :keepalivetimeout => '8765',
        :listen_addresses => ['0.0.0.0'],
        :listen_ports => %w(81 444),
        :log_level => 'warn',
        :version => '2.2',
        :package_name => 'apache2',
        :run_user => 'bob',
        :run_group => 'bob',
        :timeout => '1234'
        )
    end
  end

  it 'writes log[notify restart]' do
    expect(debian_7_2_multi_stepinto_run).to write_log('notify restart')
  end

  it 'writes log[notify reload]' do
    expect(debian_7_2_multi_stepinto_run).to write_log('notify reload')
  end

  # step_into httpd_service[default]
  context 'when stepping into the httpd_service[default] resource' do

    it 'steps into httpd_service[default] and installs package[default delete apache2]' do
      expect(debian_7_2_multi_stepinto_run).to install_package('default delete apache2').with(
        :package_name => 'apache2'
        )
    end

    it 'disables service[default delete apache2]' do
      expect(debian_7_2_multi_stepinto_run).to stop_service('default delete apache2')
      expect(debian_7_2_multi_stepinto_run).to disable_service('default delete apache2')
    end

    it 'does not run_bash[default delete remove_package_config]' do
      expect(debian_7_2_multi_stepinto_run).to_not run_bash('default delete remove_package_config').with(
        :user => 'root'
        )
    end

    it 'deletes directory[default delete /var/cache/apache2]' do
      expect(debian_7_2_multi_stepinto_run).to delete_directory('default delete /var/cache/apache2').with(
        :recursive => true
        )
    end

    it 'deletes directory[default delete /var/log/apache2]' do
      expect(debian_7_2_multi_stepinto_run).to delete_directory('default delete /var/log/apache2').with(
        :recursive => true
        )
    end

    it 'deletes directory[default delete /var/run/apache2]' do
      expect(debian_7_2_multi_stepinto_run).to delete_directory('default delete /var/run/apache2').with(
        :recursive => true
        )
    end

    it 'deletes directory[default delete /etc/apache2/conf.d]' do
      expect(debian_7_2_multi_stepinto_run).to delete_directory('default delete /etc/apache2/conf.d').with(
        :recursive => true
        )
    end

    it 'deletes directory[default delete /etc/apache2/mods-available]' do
      expect(debian_7_2_multi_stepinto_run).to delete_directory('default delete /etc/apache2/mods-available').with(
        :recursive => true
        )
    end

    it 'deletes directory[default delete /etc/apache2/mods-enabled]' do
      expect(debian_7_2_multi_stepinto_run).to delete_directory('default delete /etc/apache2/mods-enabled').with(
        :recursive => true
        )
    end

    it 'deletes directory[default delete /etc/apache2/sites-available]' do
      expect(debian_7_2_multi_stepinto_run).to delete_directory('default delete /etc/apache2/sites-available').with(
        :recursive => true
        )
    end

    it 'deletes directory[default delete /etc/apache2/sites-enabled]' do
      expect(debian_7_2_multi_stepinto_run).to delete_directory('default delete /etc/apache2/sites-enabled').with(
        :recursive => true
        )
    end

    it 'deletes file[default delete /usr/sbin/a2enmod]' do
      expect(debian_7_2_multi_stepinto_run).to delete_file('default delete /usr/sbin/a2enmod')
    end

    it 'deletes link[default delete /usr/sbin/a2dismod]' do
      expect(debian_7_2_multi_stepinto_run).to delete_link('default delete /usr/sbin/a2dismod')
    end

    it 'deletes link[default delete /usr/sbin/a2ensite]' do
      expect(debian_7_2_multi_stepinto_run).to delete_link('default delete /usr/sbin/a2ensite')
    end

    it 'deletes link[default delete /usr/sbin/a2dissite]' do
      expect(debian_7_2_multi_stepinto_run).to delete_link('default delete /usr/sbin/a2dissite')
    end

    it 'deletes file[default delete /etc/apache2/magic]' do
      expect(debian_7_2_multi_stepinto_run).to delete_file('default delete /etc/apache2/magic')
    end

    it 'deletes file[default delete /etc/apache2/ports.conf]' do
      expect(debian_7_2_multi_stepinto_run).to delete_file('default delete /etc/apache2/ports.conf')
    end
  end

  # step_into httpd_service[instance-1]
  context 'when stepping into the httpd_service[instance-1] resource' do
    it 'steps into httpd_service[instance-1] and installs package[instance-1 create apache2]' do
      expect(debian_7_2_multi_stepinto_run).to install_package('instance-1 create apache2').with(
        :package_name => 'apache2'
        )
    end

    it 'does not run_bash[instance-1 delete remove_package_config]' do
      expect(debian_7_2_multi_stepinto_run).to_not run_bash('instance-1 create remove_package_config').with(
        :user => 'root'
        )
    end

    it 'steps into httpd_service[instance-1] and creates directory[instance-1 create /var/cache/apache2-instance-1]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-1 create /var/cache/apache2-instance-1').with(
        :path => '/var/cache/apache2-instance-1',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-1] and creates directory[instance-1 create /var/log/apache2-instance-1]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-1 create /var/log/apache2-instance-1').with(
        :path => '/var/log/apache2-instance-1',
        :owner => 'root',
        :group => 'adm',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-1] and creates directory[instance-1 create /var/run/apache2-instance-1]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-1 create /var/run/apache2-instance-1').with(
        :path => '/var/run/apache2-instance-1',
        :owner => 'root',
        :group => 'adm',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-1] and creates directory[instance-1 create /etc/apache2-instance-1]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-1 create /etc/apache2-instance-1').with(
        :path => '/etc/apache2-instance-1',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-1] and creates directory[instance-1 create /etc/apache2-instance-1/conf.d]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-1 create /etc/apache2-instance-1/conf.d').with(
        :path => '/etc/apache2-instance-1/conf.d',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-1] and creates directory[instance-1 create /etc/apache2-instance-1/mods-available]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-1 create /etc/apache2-instance-1/mods-available').with(
        :path => '/etc/apache2-instance-1/mods-available',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-1] and creates directory[instance-1 create /etc/apache2-instance-1/mods-enabled]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-1 create /etc/apache2-instance-1/mods-enabled').with(
        :path => '/etc/apache2-instance-1/mods-enabled',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-1] and creates directory[instance-1 create /etc/apache2-instance-1/sites-available]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-1 create /etc/apache2-instance-1/sites-available').with(
        :path => '/etc/apache2-instance-1/sites-available',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-1] and creates directory[instance-1 create /etc/apache2-instance-1/sites-enabled]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-1 create /etc/apache2-instance-1/sites-enabled').with(
        :path => '/etc/apache2-instance-1/sites-enabled',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    # FIXME: render tempalte
    # FIXME: variables?
    it 'steps into httpd_service[instance-1] and creates template[instance-1 create /etc/apache2-instance-1/envvars]' do
      expect(debian_7_2_multi_stepinto_run).to create_template('instance-1 create /etc/apache2-instance-1/envvars').with(
        :path => '/etc/apache2-instance-1/envvars',
        :source => 'envvars.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'steps into httpd_service[instance-1] and creates template[instance-1 create /usr/sbin/a2enmod]' do
      expect(debian_7_2_multi_stepinto_run).to create_template('instance-1 create /usr/sbin/a2enmod').with(
        :path => '/usr/sbin/a2enmod',
        :source => '2.2/scripts/a2enmod.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0755',
        :cookbook => 'httpd'
        )
    end

    it 'steps into httpd_service[instance-1] and creates link[instance-1 create /usr/sbin/a2enmod-instance-1]' do
      expect(debian_7_2_multi_stepinto_run).to_not create_link('instance-1 create /usr/sbin/a2enmod-instance-1').with(
        :target_file => '/usr/sbin/a2enmod-instance-1',
        :to => '/usr/sbin/a2enmod',
        :owner => 'root',
        :group => 'root'
        )
    end

    it 'steps into httpd_service[instance-1] and creates link[instance-1 create /usr/sbin/a2dismod-instance-1]' do
      expect(debian_7_2_multi_stepinto_run).to create_link('instance-1 create /usr/sbin/a2dismod-instance-1').with(
        :target_file => '/usr/sbin/a2dismod-instance-1',
        :to => '/usr/sbin/a2enmod',
        :owner => 'root',
        :group => 'root'
        )
    end

    it 'steps into httpd_service[instance-1] and creates link[instance-1 create /usr/sbin/a2ensite-instance-1]' do
      expect(debian_7_2_multi_stepinto_run).to create_link('instance-1 create /usr/sbin/a2ensite-instance-1').with(
        :target_file => '/usr/sbin/a2ensite-instance-1',
        :to => '/usr/sbin/a2enmod',
        :owner => 'root',
        :group => 'root'
        )
    end

    it 'steps into httpd_service[instance-1] and creates link[instance-1 create /usr/sbin/a2dissite-instance-1]' do
      expect(debian_7_2_multi_stepinto_run).to create_link('instance-1 create /usr/sbin/a2dissite-instance-1').with(
        :target_file => '/usr/sbin/a2dissite-instance-1',
        :to => '/usr/sbin/a2enmod',
        :owner => 'root',
        :group => 'root'
        )
    end

    it 'steps into httpd_service[instance-1] and creates template[instance-1 create /etc/apache2-instance-1/magic]' do
      expect(debian_7_2_multi_stepinto_run).to create_template('instance-1 create /etc/apache2-instance-1/magic').with(
        :path => '/etc/apache2-instance-1/magic',
        :source => 'magic.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'steps into httpd_service[instance-1] and deletes file[instance-1 create /etc/apache2-instance-1/ports.conf]' do
      expect(debian_7_2_multi_stepinto_run).to delete_file('instance-1 create /etc/apache2-instance-1/ports.conf').with(
        :path => '/etc/apache2-instance-1/ports.conf'
        )
    end

    it 'steps into httpd_service[instance-1] and creates template[instance-1 create /etc/init.d/apache2-instance-1]' do
      expect(debian_7_2_multi_stepinto_run).to create_template('instance-1 create /etc/init.d/apache2-instance-1').with(
        :path => '/etc/init.d/apache2-instance-1',
        :source => '2.2/sysvinit/debian-7/apache2.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0755',
        :cookbook => 'httpd'
        )
    end

    # begin mpm config section
    it 'steps into httpd_service[instance-1] and installs package[instance-1 create apache2-mpm-prefork]' do
      expect(debian_7_2_multi_stepinto_run).to install_package('instance-1 create apache2-mpm-prefork').with(
        :package_name => 'apache2-mpm-prefork'
        )
    end

    # FIXME: render template
    it 'steps into httpd_service[instance-1] and creates template[instance-1 create /etc/apache2-instance-1/mods-available/mpm_prefork.conf]' do
      expect(debian_7_2_multi_stepinto_run).to create_template('instance-1 create /etc/apache2-instance-1/mods-available/mpm_prefork.conf').with(
        :path => '/etc/apache2-instance-1/mods-available/mpm_prefork.conf',
        :source => '2.2/mods/mpm.conf.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'steps into httpd_service[instance-1] and creates link[instance-1 create /etc/apache2-instance-1/mods-enabled/mpm_prefork.conf]' do
      expect(debian_7_2_multi_stepinto_run).to create_link('instance-1 create /etc/apache2-instance-1/mods-enabled/mpm_prefork.conf').with(
        :target_file => '/etc/apache2-instance-1/mods-enabled/mpm_prefork.conf',
        :to => '/etc/apache2-instance-1/mods-available/mpm_prefork.conf'
        )
    end

    it 'steps into httpd_service[instance-1] and delete file[instance-1 create /etc/apache2-instance-1/mods-available/mpm_worker.conf]' do
      expect(debian_7_2_multi_stepinto_run).to delete_file('instance-1 create /etc/apache2-instance-1/mods-available/mpm_worker.conf').with(
        :path => '/etc/apache2-instance-1/mods-available/mpm_worker.conf'
        )
    end

    it 'steps into httpd_service[instance-1] and delete link[instance-1 create /etc/apache2-instance-1/mods-enabled/mpm_worker.conf]' do
      expect(debian_7_2_multi_stepinto_run).to delete_link('instance-1 create /etc/apache2-instance-1/mods-enabled/mpm_worker.conf').with(
        :target_file => '/etc/apache2-instance-1/mods-enabled/mpm_worker.conf'
        )
    end

    it 'steps into httpd_service[instance-1] and delete file[instance-1 create /etc/apache2-instance-1/mods-available/mpm_event.conf]' do
      expect(debian_7_2_multi_stepinto_run).to delete_file('instance-1 create /etc/apache2-instance-1/mods-available/mpm_event.conf').with(
        :path => '/etc/apache2-instance-1/mods-available/mpm_event.conf'
        )
    end

    it 'steps into httpd_service[instance-1] and delete link[instance-1 create /etc/apache2-instance-1/mods-enabled/mpm_event.conf]' do
      expect(debian_7_2_multi_stepinto_run).to delete_link('instance-1 create /etc/apache2-instance-1/mods-enabled/mpm_event.conf').with(
        :target_file => '/etc/apache2-instance-1/mods-enabled/mpm_event.conf'
        )
    end

    # FIXME: render template
    it 'steps into httpd_service[instance-1] and creates template[instance-1 create /etc/apache2-instance-1/apache2.conf]' do
      expect(debian_7_2_multi_stepinto_run).to create_template('instance-1 create /etc/apache2-instance-1/apache2.conf').with(
        :path => '/etc/apache2-instance-1/apache2.conf',
        :source => 'httpd.conf.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'steps into httpd_service[instance-2] and creates template[instance-2 create /usr/sbin/a2enmod]' do
      expect(debian_7_2_multi_stepinto_run).to create_template('instance-2 create /usr/sbin/a2enmod').with(
        :path => '/usr/sbin/a2enmod',
        :source => '2.2/scripts/a2enmod.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0755',
        :cookbook => 'httpd'
        )
    end

    it 'steps into httpd_service[instance-1] and manages service[instance-1 create apache2-instance-1]' do
      expect(debian_7_2_multi_stepinto_run).to start_service('instance-1 create apache2-instance-1')
      expect(debian_7_2_multi_stepinto_run).to enable_service('instance-1 create apache2-instance-1')
    end
  end

  # step_into httpd_service[instance-2]
  context 'when stepping into the httpd_service[instance-2] resource' do
    it 'steps into httpd_service[instance-2] and installs package[instance-2 create apache2]' do
      expect(debian_7_2_multi_stepinto_run).to install_package('instance-2 create apache2').with(
        :package_name => 'apache2'
        )
    end

    it 'does not run_bash[instance-2 delete remove_package_config]' do
      expect(debian_7_2_multi_stepinto_run).to_not run_bash('instance-2 create remove_package_config').with(
        :user => 'root'
        )
    end

    it 'steps into httpd_service[instance-2] and creates directory[instance-2 create /var/cache/apache2-instance-2]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-2 create /var/cache/apache2-instance-2').with(
        :path => '/var/cache/apache2-instance-2',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-2] and creates directory[instance-2 create /var/log/apache2-instance-2]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-2 create /var/log/apache2-instance-2').with(
        :path => '/var/log/apache2-instance-2',
        :owner => 'root',
        :group => 'adm',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-2] and creates directory[instance-2 create /var/run/apache2-instance-2]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-2 create /var/run/apache2-instance-2').with(
        :path => '/var/run/apache2-instance-2',
        :owner => 'root',
        :group => 'adm',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-2] and creates directory[instance-2 create /etc/apache2-instance-2]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-2 create /etc/apache2-instance-2').with(
        :path => '/etc/apache2-instance-2',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-2] and creates directory[instance-2 create /etc/apache2-instance-2/conf.d]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-2 create /etc/apache2-instance-2/conf.d').with(
        :path => '/etc/apache2-instance-2/conf.d',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-2] and creates directory[instance-2 create /etc/apache2-instance-2/mods-available]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-2 create /etc/apache2-instance-2/mods-available').with(
        :path => '/etc/apache2-instance-2/mods-available',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-2] and creates directory[instance-2 create /etc/apache2-instance-2/mods-enabled]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-2 create /etc/apache2-instance-2/mods-enabled').with(
        :path => '/etc/apache2-instance-2/mods-enabled',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-2] and creates directory[instance-2 create /etc/apache2-instance-2/sites-available]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-2 create /etc/apache2-instance-2/sites-available').with(
        :path => '/etc/apache2-instance-2/sites-available',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    it 'steps into httpd_service[instance-2] and creates directory[instance-2 create /etc/apache2-instance-2/sites-enabled]' do
      expect(debian_7_2_multi_stepinto_run).to create_directory('instance-2 create /etc/apache2-instance-2/sites-enabled').with(
        :path => '/etc/apache2-instance-2/sites-enabled',
        :owner => 'root',
        :group => 'root',
        :mode => '0755'
        )
    end

    # FIXME: render tempalte
    # FIXME: variables?
    it 'steps into httpd_service[instance-2] and creates template[instance-2 create /etc/apache2-instance-2/envvars]' do
      expect(debian_7_2_multi_stepinto_run).to create_template('instance-2 create /etc/apache2-instance-2/envvars').with(
        :path => '/etc/apache2-instance-2/envvars',
        :source => 'envvars.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'steps into httpd_service[instance-2] and creates link[instance-2 create /usr/sbin/a2enmod-instance-2]' do
      expect(debian_7_2_multi_stepinto_run).to_not create_link('instance-2 create /usr/sbin/a2enmod-instance-2').with(
        :target_file => '/usr/sbin/a2enmod-instance-2',
        :to => '/usr/sbin/a2enmod',
        :owner => 'root',
        :group => 'root'
        )
    end

    it 'steps into httpd_service[instance-2] and creates link[instance-2 create /usr/sbin/a2dismod-instance-2]' do
      expect(debian_7_2_multi_stepinto_run).to create_link('instance-2 create /usr/sbin/a2dismod-instance-2').with(
        :target_file => '/usr/sbin/a2dismod-instance-2',
        :to => '/usr/sbin/a2enmod',
        :owner => 'root',
        :group => 'root'
        )
    end

    it 'steps into httpd_service[instance-2] and creates link[instance-2 create /usr/sbin/a2ensite-instance-2]' do
      expect(debian_7_2_multi_stepinto_run).to create_link('instance-2 create /usr/sbin/a2ensite-instance-2').with(
        :target_file => '/usr/sbin/a2ensite-instance-2',
        :to => '/usr/sbin/a2enmod',
        :owner => 'root',
        :group => 'root'
        )
    end

    it 'steps into httpd_service[instance-2] and creates link[instance-2 create /usr/sbin/a2dissite-instance-2]' do
      expect(debian_7_2_multi_stepinto_run).to create_link('instance-2 create /usr/sbin/a2dissite-instance-2').with(
        :target_file => '/usr/sbin/a2dissite-instance-2',
        :to => '/usr/sbin/a2enmod',
        :owner => 'root',
        :group => 'root'
        )
    end

    it 'steps into httpd_service[instance-2] and creates template[instance-2 create /etc/apache2-instance-2/magic]' do
      expect(debian_7_2_multi_stepinto_run).to create_template('instance-2 create /etc/apache2-instance-2/magic').with(
        :path => '/etc/apache2-instance-2/magic',
        :source => 'magic.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'steps into httpd_service[instance-2] and deletes file[instance-2 create /etc/apache2-instance-2/ports.conf]' do
      expect(debian_7_2_multi_stepinto_run).to delete_file('instance-2 create /etc/apache2-instance-2/ports.conf').with(
        :path => '/etc/apache2-instance-2/ports.conf'
        )
    end

    it 'steps into httpd_service[instance-2] and creates template[instance-2 create /etc/init.d/apache2-instance-2]' do
      expect(debian_7_2_multi_stepinto_run).to create_template('instance-2 create /etc/init.d/apache2-instance-2').with(
        :path => '/etc/init.d/apache2-instance-2',
        :source => '2.2/sysvinit/debian-7/apache2.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0755',
        :cookbook => 'httpd'
        )
    end

    # begin mpm config section
    it 'steps into httpd_service[instance-2] and installs package[instance-2 create apache2-mpm-prefork]' do
      expect(debian_7_2_multi_stepinto_run).to install_package('instance-2 create apache2-mpm-prefork').with(
        :package_name => 'apache2-mpm-prefork'
        )
    end

    # FIXME: render template
    it 'steps into httpd_service[instance-2] and creates template[instance-2 create /etc/apache2-instance-2/mods-available/mpm_prefork.conf]' do
      expect(debian_7_2_multi_stepinto_run).to create_template('instance-2 create /etc/apache2-instance-2/mods-available/mpm_prefork.conf').with(
        :path => '/etc/apache2-instance-2/mods-available/mpm_prefork.conf',
        :source => '2.2/mods/mpm.conf.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'steps into httpd_service[instance-2] and creates link[instance-2 create /etc/apache2-instance-2/mods-enabled/mpm_prefork.conf]' do
      expect(debian_7_2_multi_stepinto_run).to create_link('instance-2 create /etc/apache2-instance-2/mods-enabled/mpm_prefork.conf').with(
        :target_file => '/etc/apache2-instance-2/mods-enabled/mpm_prefork.conf',
        :to => '/etc/apache2-instance-2/mods-available/mpm_prefork.conf'
        )
    end

    it 'steps into httpd_service[instance-2] and delete file[instance-2 create /etc/apache2-instance-2/mods-available/mpm_worker.conf]' do
      expect(debian_7_2_multi_stepinto_run).to delete_file('instance-2 create /etc/apache2-instance-2/mods-available/mpm_worker.conf').with(
        :path => '/etc/apache2-instance-2/mods-available/mpm_worker.conf'
        )
    end

    it 'steps into httpd_service[instance-2] and delete link[instance-2 create /etc/apache2-instance-2/mods-enabled/mpm_worker.conf]' do
      expect(debian_7_2_multi_stepinto_run).to delete_link('instance-2 create /etc/apache2-instance-2/mods-enabled/mpm_worker.conf').with(
        :target_file => '/etc/apache2-instance-2/mods-enabled/mpm_worker.conf'
        )
    end

    it 'steps into httpd_service[instance-2] and delete file[instance-2 create /etc/apache2-instance-2/mods-available/mpm_event.conf]' do
      expect(debian_7_2_multi_stepinto_run).to delete_file('instance-2 create /etc/apache2-instance-2/mods-available/mpm_event.conf').with(
        :path => '/etc/apache2-instance-2/mods-available/mpm_event.conf'
        )
    end

    it 'steps into httpd_service[instance-2] and delete link[instance-2 create /etc/apache2-instance-2/mods-enabled/mpm_event.conf]' do
      expect(debian_7_2_multi_stepinto_run).to delete_link('instance-2 create /etc/apache2-instance-2/mods-enabled/mpm_event.conf').with(
        :target_file => '/etc/apache2-instance-2/mods-enabled/mpm_event.conf'
        )
    end

    # FIXME: render template
    it 'steps into httpd_service[instance-2] and creates template[instance-2 create /etc/apache2-instance-2/apache2.conf]' do
      expect(debian_7_2_multi_stepinto_run).to create_template('instance-2 create /etc/apache2-instance-2/apache2.conf').with(
        :path => '/etc/apache2-instance-2/apache2.conf',
        :source => 'httpd.conf.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
        :cookbook => 'httpd'
        )
    end

    it 'steps into httpd_service[instance-2] and manages service[instance-2 create apache2-instance-2]' do
      expect(debian_7_2_multi_stepinto_run).to start_service('instance-2 create apache2-instance-2')
      expect(debian_7_2_multi_stepinto_run).to enable_service('instance-2 create apache2-instance-2')
    end
  end
end
