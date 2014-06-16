require 'serverspec'

include Serverspec::Helper::Exec

describe port(80) do
  it { should be_listening.with('tcp') }
end

describe port(443) do
  it { should be_listening.with('tcp') }
end
