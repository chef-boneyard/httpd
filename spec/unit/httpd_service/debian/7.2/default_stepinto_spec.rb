require 'spec_helper'

describe 'httpd_test_default::server on debian-7.2' do

  let(:httpd_conf_content) do
  end

  let(:debian_7_2_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'httpd_service',
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['httpd']['service_name'] = 'debian_7_2_default_stepinto'
    end.converge('httpd_test_default::server')
  end

  context 'when using default parameters' do
    it 'creates httpd_service[debian_7_2_default]' do
      expect(debian_7_2_default_stepinto_run).to create_httpd_service('debian_7_2_default_stepinto').with(
        :version => '2.2',
        :listen_addresses => nil,
        :listen_ports => %w(80 443),
        :contact => 'webmaster@localhost',
        :timeout => '400',
        :keepalive => true,
        :keepaliverequests => '100',
        :keepalivetimeout => '5'
        )
    end

    it 'steps into httpd_service and installs package[apache2]' do
      expect(debian_7_2_default_stepinto_run).to install_package('apache2')
    end

    it 'steps into httpd_service and creates directory[/etc/apache2]' do
      expect(debian_7_2_default_stepinto_run).to create_directory('/etc/apache2')
    end

    it 'steps into httpd_service and creates template[/etc/apache2/apache2.conf]' do
      expect(debian_7_2_default_stepinto_run).to create_template('/etc/apache2/apache2.conf')
    end

    it 'steps into httpd_service and manages service[apache2]' do
      expect(debian_7_2_default_stepinto_run).to start_service('apache2')
      expect(debian_7_2_default_stepinto_run).to enable_service('apache2')
    end
  end
end
