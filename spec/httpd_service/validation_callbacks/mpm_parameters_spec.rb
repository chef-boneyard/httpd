require 'spec_helper'

describe 'httpd_service::single on debian-7.2 with invalid parameter' do
  let(:chef_run_2_2_1) do
    ChefSpec::Runner.new(
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['httpd']['version'] = '2.2'
      node.set['httpd']['mpm'] = 'worker'
      node.set['httpd']['minspareservers'] = '42'
    end.converge('httpd_service::single')
  end

  context 'when using broken parameters' do
    it 'creates raises an error' do
      expect { chef_run_2_2_1 }.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end
end

describe 'httpd_service::single 2.2 on debian-7.2 with valid parameter' do
  let(:chef_run_2_2_2) do
    ChefSpec::Runner.new(
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['httpd']['version'] = '2.2'
      node.set['httpd']['mpm'] = 'prefork'
      node.set['httpd']['minspareservers'] = '42'
    end.converge('httpd_service::single')
  end

  context 'when using broken parameters' do
    it 'creates raises an error' do
      expect { chef_run_2_2_2 }.not_to raise_error
    end
  end
end

describe 'httpd_service::single 2.4 on ubuntu 14.04 with invalid parameter' do
  let(:chef_run_2_4_1) do
    ChefSpec::Runner.new(
      :platform => 'ubuntu',
      :version => '14.04'
      ) do |node|
      node.set['httpd']['version'] = '2.4'
      node.set['httpd']['mpm'] = 'event'
      node.set['httpd']['maxclients'] = '42'
    end.converge('httpd_service::single')
  end

  context 'when using broken parameters' do
    it 'creates raises an error' do
      expect { chef_run_2_4_1 }.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end
end

describe 'httpd_service::single 2.4 on ubuntu 14.04 with valid parameter' do
  let(:chef_run_2_4_2) do
    ChefSpec::Runner.new(
      :platform => 'ubuntu',
      :version => '14.04'
      ) do |node|
      node.set['httpd']['version'] = '2.4'
      node.set['httpd']['mpm'] = 'event'
      node.set['httpd']['threadlimit'] = '42'
    end.converge('httpd_service::single')
  end

  context 'when using broken parameters' do
    it 'creates raises an error' do
      expect { chef_run_2_4_2 }.not_to raise_error
    end
  end
end
