require 'serverspec'

puts "os[:family] #{os[:family]}"

set :backend, :exec

if os[:family] =~ /redhat/ || os[:family] =~ /fedora/
  describe file('/etc/httpd-default/conf.d') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd-default/conf.d/hello.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should eq "# hello there\n" }
  end

  describe file('/etc/httpd-foo/conf.d') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd-foo/conf.d/hello_again.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should eq "# hello there\n" }
  end
end
