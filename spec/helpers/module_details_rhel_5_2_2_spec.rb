require_relative '../../libraries/module_details_rhel.rb'
require_relative '../../libraries/module_details_dsl.rb'

describe 'looking up module package name' do
  before do
    extend Httpd::Module::Helpers
  end

  context 'for apache 2.2 on rhel 5' do
    it 'returns the proper list of files' do
      expect(
        delete_files_for_module('auth_kerb', '2.2', 'centos', 'rhel', '5.5')
        ).to eq(['/etc/httpd/conf.d/auth_kerb.conf'])
    end
  end
end
