require 'serverspec'

puts "os[:family] #{os[:family]}"

set :backend, :exec

if os[:family] =~ /redhat/ || os[:family] =~ /fedora/
  # auth_basic
  describe file('/usr/lib64/httpd/modules/mod_auth_basic.so') do
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd-default/conf.modules.d') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd-default/conf.modules.d/auth_basic.load') do
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

  describe file('/etc/httpd-default/conf.modules.d') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd-default/conf.modules.d/auth_kerb.load') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
