describe port(80) do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end
