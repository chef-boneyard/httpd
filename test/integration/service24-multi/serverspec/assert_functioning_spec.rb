require 'serverspec'

set :backend, :exec

describe port(80) do
  it { should_not be_listening.with('tcp') }
end

describe port(443) do
  it { should_not be_listening.with('tcp') }
end

describe port(81) do
  it { should be_listening.with('tcp') }
end

describe port(444) do
  it { should be_listening.with('tcp') }
end

describe port(8080) do
  it { should be_listening.with('tcp') }
end

describe port(4343) do
  it { should be_listening.with('tcp') }
end
