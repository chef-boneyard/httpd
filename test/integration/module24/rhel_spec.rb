if os[:family] == 'centos' || os[:family] == 'fedora' || os[:family] == 'opensuse'
  # auth_basic
  describe file('/usr/lib64/httpd/modules/mod_auth_basic.so') do
    it { should be_file }
    its('mode') { should eq 00755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd-default/conf.modules.d') do
    it { should be_directory }
    its('mode') { should eq 00755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd-default/conf.modules.d/auth_basic.load') do
    it { should be_file }
    its('mode') { should eq 00644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  # auth_kerb
  describe file('/usr/lib64/httpd/modules/mod_expires.so') do
    it { should be_file }
    its('mode') { should eq 00755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd-default/conf.modules.d') do
    it { should be_directory }
    its('mode') { should eq 00755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd-default/conf.modules.d/expires.load') do
    it { should be_file }
    its('mode') { should eq 00644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
