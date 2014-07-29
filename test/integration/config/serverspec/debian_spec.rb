require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

property[:os] = backend.check_os
platform = property[:os][:family]
platform_version = property[:os][:release]

if platform =~ /Debian/
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

  describe file('/etc/apache2-foo/conf.d/hello_again.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

if platform =~ /Ubuntu/
  if platform_version =~ /12.04/
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

    describe file('/etc/apache2-foo/conf.d/hello_again.conf') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

  elsif platform_version =~ /14.04/
    describe file('/etc/apache2/conf-available') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/apache2/conf-enabled') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/apache2/conf-available/hello.conf') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/apache2/conf-enabled/hello.conf') do
      it { should be_file }
      it { should be_mode 777 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_linked_to '/etc/apache2/conf-available/hello.conf' }
    end

    describe file('/etc/apache2-foo/conf-available') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/apache2-foo/conf-enabled') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/apache2-foo/conf-available/hello_again.conf') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/apache2-foo/conf-enabled/hello_again.conf') do
      it { should be_file }
      it { should be_mode 777 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_linked_to '/etc/apache2-foo/conf-available/hello_again.conf' }
    end
  end
end
