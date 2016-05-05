if os[:family] == 'debian' || os[:family] == 'ubuntu'
  # auth_basic
  describe file('/usr/lib/apache2/modules/mod_auth_basic.so') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should eq 00644 }
  end

  describe file('/etc/apache2-default/mods-available') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should eq 00755 }
  end

  describe file('/etc/apache2-default/mods-enabled') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should eq 00755 }
  end

  describe file('/etc/apache2-default/mods-available/auth_basic.load') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should eq 00644 }
  end

  describe file('/etc/apache2-default/mods-enabled/auth_basic.load') do
    it { should be_linked_to '/etc/apache2-default/mods-available/auth_basic.load' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should eq 00777 }
  end

  describe file('/etc/apache2-default/mods-available/expires.load') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should eq 00644 }
  end

  describe file('/etc/apache2-default/mods-enabled/expires.load') do
    it { should be_linked_to '/etc/apache2-default/mods-available/expires.load' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should eq 00777 }
  end
end
