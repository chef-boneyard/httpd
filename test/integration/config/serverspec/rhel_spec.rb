require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

property[:os] = backend.check_os
platform = property[:os][:family]

if platform =~ /RedHat/ || platform =~ /RedHat7/ || platform =~ /Fedora/
  describe file('/etc/httpd/conf.d') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/httpd/conf.d/hello.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
