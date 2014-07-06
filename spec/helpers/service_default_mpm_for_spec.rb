require_relative '../../libraries/service_default_mpm_for.rb'

describe 'default_mpm_for' do
  before do
    extend Opscode::Httpd::Service::Helpers
  end

  context 'when using apache 2.2' do
    it 'returns the correct mpm' do
      expect(default_mpm_for('2.2')).to eq('worker')
    end
  end

  context 'when using apache 2.4' do
    it 'returns the correct mpm' do
      expect(default_mpm_for('2.4')).to eq('event')
    end
  end
end
