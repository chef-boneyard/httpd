require 'spec_helper'

describe 'httpd_test_default::server 2.2 on debian-7.2' do
  let(:debian_7_2_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'debian',
      :version => '7.2'
      ).converge('httpd_test_default::server')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[default]' do
      expect(debian_7_2_default_stepinto_run).to create_httpd_service('default').with(
        :contact => 'webmaster@localhost',
        :hostname_lookups => 'off',
        :keepalive => true,
        :keepaliverequests => '100',
        :keepalivetimeout => '5',
        :listen_addresses => nil,
        :listen_ports => %w(80 443),
        :log_level => 'warn',
        :version => '2.2',
        :package_name => 'apache2',
        :run_user => 'www-data',
        :run_group => 'www-data',
        :timeout => '400'
        )
    end
  end

  it 'steps into httpd_service[default] and installs package[apache2]' do
    expect(debian_7_2_default_stepinto_run).to install_package('apache2')
  end

  it 'steps into httpd_service[default] and creates directory[/var/cache/apache2]' do
    expect(debian_7_2_default_stepinto_run).to create_directory('/var/cache/apache2').with(
      :owner => 'root',
      :group => 'root',
      :mode => '0755'
      )
  end

  it 'steps into httpd_service[default] and creates directory[/var/log/apache2]' do
    expect(debian_7_2_default_stepinto_run).to create_directory('/var/log/apache2').with(
      :owner => 'root',
      :group => 'adm',
      :mode => '0755'
      )
  end

  it 'steps into httpd_service[default] and creates directory[/var/run/apache2]' do
    expect(debian_7_2_default_stepinto_run).to create_directory('/var/run/apache2').with(
      :owner => 'root',
      :group => 'adm',
      :mode => '0755'
      )
  end

  it 'steps into httpd_service[default] and creates directory[/etc/apache2]' do
    expect(debian_7_2_default_stepinto_run).to create_directory('/etc/apache2').with(
      :owner => 'root',
      :group => 'root',
      :mode => '0755'
      )
  end

  it 'steps into httpd_service[default] and creates directory[/etc/apache2/conf.d]' do
    expect(debian_7_2_default_stepinto_run).to create_directory('/etc/apache2/conf.d').with(
      :owner => 'root',
      :group => 'root',
      :mode => '0755'
      )
  end

  it 'steps into httpd_service[default] and creates directory[/etc/apache2/mods-available]' do
    expect(debian_7_2_default_stepinto_run).to create_directory('/etc/apache2/mods-available').with(
      :owner => 'root',
      :group => 'root',
      :mode => '0755'
      )
  end

  it 'steps into httpd_service[default] and creates directory[/etc/apache2/mods-enabled]' do
    expect(debian_7_2_default_stepinto_run).to create_directory('/etc/apache2/mods-enabled').with(
      :owner => 'root',
      :group => 'root',
      :mode => '0755'
      )
  end

  it 'steps into httpd_service[default] and creates directory[/etc/apache2/sites-available]' do
    expect(debian_7_2_default_stepinto_run).to create_directory('/etc/apache2/sites-available').with(
      :owner => 'root',
      :group => 'root',
      :mode => '0755'
      )
  end

  it 'steps into httpd_service[default] and creates directory[/etc/apache2/sites-enabled]' do
    expect(debian_7_2_default_stepinto_run).to create_directory('/etc/apache2/sites-enabled').with(
      :owner => 'root',
      :group => 'root',
      :mode => '0755'
      )
  end

  # FIXME: render tempalte
  # FIXME: variables?
  it 'steps into httpd_service[default] and creates template[/etc/apache2/envvars]' do
    expect(debian_7_2_default_stepinto_run).to create_template('/etc/apache2/envvars').with(
      :source => '2.2/envvars.erb',
      :owner => 'root',
      :group => 'root',
      :mode => '0644',
      :cookbook => 'httpd'
      )
  end

  it 'steps into httpd_service[default] and creates template[/usr/sbin/a2enmod]' do
    expect(debian_7_2_default_stepinto_run).to create_template('/usr/sbin/a2enmod').with(
      :source => '2.2/scripts/a2enmod.erb',
      :owner => 'root',
      :group => 'root',
      :mode => '0755',
      :cookbook => 'httpd'
      )
  end

  it 'steps into httpd_service[default] and creates link[/usr/sbin/a2enmod]' do
    expect(debian_7_2_default_stepinto_run).to create_link('/usr/sbin/a2enmod').with(
      :to => '/usr/sbin/a2enmod',
      :owner => 'root',
      :group => 'root'
      )
  end

  it 'steps into httpd_service[default] and creates link[/usr/sbin/a2dismod]' do
    expect(debian_7_2_default_stepinto_run).to create_link('/usr/sbin/a2dismod').with(
      :to => '/usr/sbin/a2enmod',
      :owner => 'root',
      :group => 'root'
      )
  end

  it 'steps into httpd_service[default] and creates link[/usr/sbin/a2ensite]' do
    expect(debian_7_2_default_stepinto_run).to create_link('/usr/sbin/a2ensite').with(
      :to => '/usr/sbin/a2enmod',
      :owner => 'root',
      :group => 'root'
      )
  end

  it 'steps into httpd_service[default] and creates link[/usr/sbin/a2dissite]' do
    expect(debian_7_2_default_stepinto_run).to create_link('/usr/sbin/a2dissite').with(
      :to => '/usr/sbin/a2enmod',
      :owner => 'root',
      :group => 'root'
      )
  end

  it 'steps into httpd_service[default] and creates template[/etc/init.d/apache2]' do
    expect(debian_7_2_default_stepinto_run).to create_template('/etc/init.d/apache2').with(
      :source => '2.2/sysvinit/apache2.erb',
      :owner => 'root',
      :group => 'root',
      :mode => '0755',
      :cookbook => 'httpd'
      )
  end

  # FIXME: render template
  it 'steps into httpd_service[default] and creates template[/etc//apache2/apache2.conf]' do
    expect(debian_7_2_default_stepinto_run).to create_template('/etc/apache2/apache2.conf').with(
      :source => '2.2/apache2.conf.erb',
      :owner => 'root',
      :group => 'root',
      :mode => '0644',
      :cookbook => 'httpd'
      )
  end

  it 'steps into httpd_service[default] and manages service[apache2]' do
    expect(debian_7_2_default_stepinto_run).to start_service('apache2')
    expect(debian_7_2_default_stepinto_run).to enable_service('apache2')
  end
end
