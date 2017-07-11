require_relative '../../libraries/info_service_packages'

describe 'package_name_for_service' do
  before do
    extend HttpdCookbook::Helpers
  end

  context 'when on centos' do
    context 'version 6' do
      it 'returns the correct package_name' do
        expect(
          package_name_for_service('centos', 'rhel', '6.4', '2.2')
        ).to eq('httpd')
      end
    end
  end

  context 'when on centos' do
    context 'version 7' do
      it 'returns the correct package_name' do
        expect(
          package_name_for_service('centos', 'rhel', '7.0', '2.4')
        ).to eq('httpd')
      end
    end
  end

  # TODO: Fill these out more
end
