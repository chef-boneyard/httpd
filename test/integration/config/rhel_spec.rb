if os[:family] == 'centos' || os[:family] == 'fedora' || os[:family] == 'opensuse'
  describe file('/etc/httpd-default/conf.d') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should eq 00755 }
  end

  describe file('/etc/httpd-default/conf.d/hello.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('content') { should eq "# hello there\n" }
    its('mode') { should eq 00644 }
  end

  describe file('/etc/httpd-foo/conf.d') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should eq 00755 }
  end

  describe file('/etc/httpd-foo/conf.d/hello_again.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('content') { should eq "# hello there\n" }
    its('mode') { should eq 00644 }
  end
end
