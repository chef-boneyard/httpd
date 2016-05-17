if os[:family] == 'debian' || os[:family] == 'ubuntu'
  if os[:release].to_i == 7 || os[:release].to_f == 12.04
    describe file('/etc/apache2-default/conf.d') do
      it { should be_directory }
      its('mode') { should eq 00755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/apache2-default/conf.d/hello.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should eq 00644 }
    end

    describe file('/etc/apache2-foo/conf.d/hello_again.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should eq 00644 }
    end
  else
    describe file('/etc/apache2-default/conf-available') do
      it { should be_directory }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should eq 00755 }
    end

    describe file('/etc/apache2-default/conf-enabled') do
      it { should be_directory }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should eq 00755 }
    end

    describe file('/etc/apache2-default/conf-available/hello.conf') do
      it { should be_file }
      its('mode') { should eq 00644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/apache2-default/conf-enabled/hello.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_linked_to '/etc/apache2-default/conf-available/hello.conf' }
    end

    describe file('/etc/apache2-foo/conf-available') do
      it { should be_directory }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should eq 00755 }
    end

    describe file('/etc/apache2-foo/conf-enabled') do
      it { should be_directory }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should eq 00755 }
    end

    describe file('/etc/apache2-foo/conf-available/hello_again.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should eq 00644 }
    end

    describe file('/etc/apache2-foo/conf-enabled/hello_again.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_linked_to '/etc/apache2-foo/conf-available/hello_again.conf' }
    end
  end
end
