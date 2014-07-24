require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

property[:os] = backend.check_os
platform = property[:os][:family]
platform_version = property[:os][:release]

puts "DEBUG: platform: #{platform}"
puts "DEBUG: platform_version: #{platform_version}"

if platform =~ /RedHat/ || platform =~ /RedHat7/ || platform =~ /Fedora/
  # auth_basic
  describe file('/usr/lib64/httpd/modules/mod_auth_basic.so') do
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd/conf.modules.d') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd/conf.modules.d/auth_basic.load') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  # auth_kerb
  describe file('/usr/lib64/httpd/modules/mod_auth_kerb.so') do
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd/conf.modules.d') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd/conf.modules.d/auth_kerb.load') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
