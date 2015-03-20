require 'serverspec'

puts "os: #{os}"

set :backend, :exec

if os[:family] =~ /debian/
  describe file('/etc/apache2-default/conf.d') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/apache2-default/conf.d/hello.conf') do
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

if os[:family] =~ /ubuntu/
  if os[:release] =~ /10.04/ || os[:release] =~ /12.04/
    describe file('/etc/apache2-default/conf.d') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/apache2-default/conf.d/hello.conf') do
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

  elsif os[:release] =~ /14.04/
    describe file('/etc/apache2-default/conf-available') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/apache2-default/conf-enabled') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/apache2-default/conf-available/hello.conf') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/apache2-default/conf-enabled/hello.conf') do
      it { should be_file }
      it { should be_mode 777 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_linked_to '/etc/apache2-default/conf-available/hello.conf' }
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
