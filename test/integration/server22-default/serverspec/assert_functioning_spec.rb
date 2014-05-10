require 'serverspec'

include Serverspec::Helper::Exec

describe command("ps -ef | grep 'apache2 -k start' | grep -v grep | wc -l") do
  it { should return_exit_status 0 }
end
