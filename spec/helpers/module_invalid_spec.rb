require_relative '../../libraries/info_module_packages'

describe 'looking up module package name' do
  before do
    extend HttpdCookbook::Helpers
  end

  it 'returns nil when looking up an invalid package' do
    expect(
      package_name_for_module('asdasd', '2.2', 'debian', 'debian', '7.2')
    ).to eq(nil)
  end

  it 'returns nil when looking up an invalid version' do
    expect(
      package_name_for_module('asdasd', '2.4', 'debian', 'debian', '7.2')
    ).to eq(nil)
  end
end
