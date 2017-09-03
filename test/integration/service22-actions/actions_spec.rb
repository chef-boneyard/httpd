case os[:family]
when 'redhat'
  service_prefix = 'httpd'
  apache_conf = 'conf/httpd.conf'
when 'debian'
  service_prefix = 'apache2'
  apache_conf = 'apache2.conf'
end

service_create  = "#{service_prefix}-create_test"
service_delete  = "#{service_prefix}-delete_test"
service_start   = "#{service_prefix}-start_test"
service_stop    = "#{service_prefix}-stop_test"
service_restart = "#{service_prefix}-restart_test"
service_reload  = "#{service_prefix}-reload_test"

describe file("/etc/#{service_create}/#{apache_conf}") do
  it { is_expected.to exist }
end

describe service(service_create) do
  it { is_expected.to be_installed }
  it { is_expected.to_not be_running }
end

describe port(8101) do
  it { is_expected.to_not be_listening }
end

describe directory("/etc/#{service_delete}/") do
  it { is_expected.to_not exist }
end

describe service(service_delete) do
  it { is_expected.to_not be_installed }
  it { is_expected.to_not be_running }
end

describe port(8102) do
  it { is_expected.to_not be_listening }
end

describe file("/etc/#{service_start}/#{apache_conf}") do
  it { is_expected.to exist }
end

describe service(service_start) do
  it { is_expected.to be_installed }
  it { is_expected.to be_running }
end

describe port(8103) do
  it { is_expected.to be_listening }
end

describe file("/etc/#{service_stop}/#{apache_conf}") do
  it { is_expected.to exist }
end

describe service(service_stop) do
  it { is_expected.to be_installed }
  it { is_expected.to_not be_running }
end

describe port(8104) do
  it { is_expected.to_not be_listening }
end

describe file("/etc/#{service_restart}/#{apache_conf}") do
  it { is_expected.to exist }
end

describe service(service_restart) do
  it { is_expected.to be_installed }
  it { is_expected.to be_running }
end

describe port(8105) do
  it { is_expected.to be_listening }
end

describe port(8106) do
  it { is_expected.to be_listening }
end

describe file('/restart-pre-action-pids') do
  it { is_expected.to exist }
  example { expect(subject.content.to_i).to be > 0 }
end

describe file('/restart-post-action-pids') do
  it { is_expected.to exist }
  example { expect(subject.content.to_i).to be > 0 }
  example do
    expect(subject.content.strip)
      .to_not eq(file('/restart-pre-action-pids').content.strip)
  end
end

describe file("/etc/#{service_reload}/#{apache_conf}") do
  it { is_expected.to exist }
end

describe service(service_reload) do
  it { is_expected.to be_installed }
  it { is_expected.to be_running }
end

describe port(8107) do
  it { is_expected.to be_listening }
end

describe port(8108) do
  it { is_expected.to be_listening }
end

describe file('/reload-pre-action-pids') do
  it { is_expected.to exist }
  example { expect(subject.content.to_i).to be > 0 }
end

describe file('/reload-post-action-pids') do
  it { is_expected.to exist }
  example { expect(subject.content.to_i).to be > 0 }
  example do
    expect(subject.content.strip)
      .to eq(file('/reload-pre-action-pids').content.strip)
  end
end
