require 'serverspec'

include Serverspec::Helper::Exec
include  Serverspec::Helper::DetectOS

property[:os] = backend.check_os
os = property[:os][:family]

if os =~ /Debian/ || os =~ /Ubuntu/
  describe file('/etc/apache2/conf.d') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/apache2/conf.d/hello.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
