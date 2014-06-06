require_relative '../../libraries/helpers.rb'

describe 'httpd_platform_map' do
  before do
    extend Opscode::Httpd::Helpers
  end

  # rhel-5
  context 'for rhel-5' do
    context 'when looking up default version' do
      it 'returns the correct version' do
        expect(
          default_version_for('centos', 'rhel', '5.8')
          ).to eq('2.2')
      end
    end

    context 'when looking up package' do
      it 'returns the correct package for httpd 2.2' do
        expect(
          package_name_for('centos', 'rhel', '5.8', '2.2')
          ).to eq('httpd')
      end

      it 'returns the correct package for httpd 2.4' do
        expect(
          package_name_for('centos', 'rhel', '5.8', '2.4')
          ).to eq(nil)
      end
    end
  end

  # rhel-6
  context 'for rhel-6' do
    context 'when looking up default version' do
      it 'returns the correct version' do
        expect(
          default_version_for('centos', 'rhel', '6.4')
          ).to eq('2.2')
      end
    end

    context 'when looking up package' do
      it 'returns the correct package for httpd 2.2' do
        expect(
          package_name_for('centos', 'rhel', '6.4', '2.2')
          ).to eq('httpd')
      end

      it 'returns the correct package for httpd 2.4' do
        expect(
          package_name_for('centos', 'rhel', '6.4', '2.4')
          ).to eq(nil)
      end
    end
  end

  # amazon-13.09
  context 'for amazon-2013.09' do
    context 'when looking up default version' do
      it 'returns the correct version' do
        expect(
          default_version_for('amazon', 'rhel', '2013.09')
          ).to eq('2.4')
      end
    end

    context 'when looking up package' do
      it 'returns the correct package for httpd 2.2' do
        expect(
          package_name_for('amazon', 'rhel', '2013.09', '2.2')
          ).to eq('httpd')
      end

      it 'returns the correct package for httpd 2.4' do
        expect(
          package_name_for('amazon', 'rhel', '2013.09', '2.4')
          ).to eq('httpd24')
      end
    end
  end

  # fedora-19
  context 'for fedora-19' do
    context 'when looking up default version' do
      it 'returns the correct version' do
        expect(
          default_version_for('fedora', 'fedora', '19')
          ).to eq('2.4')
      end
    end

    context 'when looking up package' do
      it 'returns the correct package for httpd 2.2' do
        expect(
          package_name_for('fedora', 'fedora', '19', '2.2')
          ).to eq(nil)
      end

      it 'returns the correct package for httpd 2.4' do
        expect(
          package_name_for('fedora', 'fedora', '19', '2.4')
          ).to eq('httpd')
      end
    end
  end

  # debian-7
  context 'for debian-7' do
    context 'when looking up default version' do
      it 'returns the correct version' do
        expect(
          default_version_for('debian', 'debian', '7.2')
          ).to eq('2.2')
      end
    end

    context 'when looking up package' do
      it 'returns the correct package for httpd 2.2' do
        expect(
          package_name_for('debian', 'debian', '7.2', '2.2')
          ).to eq('apache2')
      end

      it 'returns the correct package for httpd 2.4' do
        expect(
          package_name_for('debian', 'debian', '7.2', '2.4')
          ).to eq(nil)
      end
    end
  end

  # ubuntu-12.04
  context 'for ubuntu-12.04' do
    context 'when looking up default version' do
      it 'returns the correct version' do
        expect(
          default_version_for('ubuntu', 'debian', '12.04')
          ).to eq('2.2')
      end
    end

    context 'when looking up package' do
      it 'returns the correct package for httpd 2.2' do
        expect(
          package_name_for('ubuntu', 'debian', '12.04', '2.2')
          ).to eq('apache2')
      end

      it 'returns the correct package for httpd 2.4' do
        expect(
          package_name_for('ubuntu', 'debian', '12.04', '2.4')
          ).to eq(nil)
      end
    end
  end

  # ubuntu-13.10
  context 'for ubuntu-13.10' do
    context 'when looking up default version' do
      it 'returns the correct version' do
        expect(
          default_version_for('ubuntu', 'debian', '13.10')
          ).to eq('2.2')
      end
    end

    context 'when looking up package' do
      it 'returns the correct package for httpd 2.2' do
        expect(
          package_name_for('ubuntu', 'debian', '13.10', '2.2')
          ).to eq('apache2')
      end

      it 'returns the correct package for httpd 2.4' do
        expect(
          package_name_for('ubuntu', 'debian', '13.10', '2.4')
          ).to eq(nil)
      end
    end
  end

  # ubuntu-14.04
  context 'for ubuntu-14.04' do
    context 'when looking up default version' do
      it 'returns the correct version' do
        expect(
          default_version_for('ubuntu', 'debian', '14.04')
          ).to eq('2.4')
      end
    end

    context 'when looking up package' do
      it 'returns the correct package for httpd 2.2' do
        expect(
          package_name_for('ubuntu', 'debian', '14.04', '2.2')
          ).to eq(nil)
      end

      it 'returns the correct package for httpd 2.4' do
        expect(
          package_name_for('ubuntu', 'debian', '14.04', '2.4')
          ).to eq('apache2')
      end
    end
  end

  # smartos-5.11
  context 'for smartos-5.11' do
    context 'when looking up default version' do
      it 'returns the correct version' do
        expect(
          default_version_for('smartos', 'smartos', '5.11')
          ).to eq('2.4')
      end
    end

    context 'when looking up package' do
      it 'returns the correct package for httpd 2.0' do
        expect(
          package_name_for('smartos', 'smartos', '5.11', '2.0')
          ).to eq('apache')
      end

      it 'returns the correct package for httpd 2.2' do
        expect(
          package_name_for('smartos', 'smartos', '5.11', '2.2')
          ).to eq('apache')
      end

      it 'returns the correct package for httpd 2.4' do
        expect(
          package_name_for('smartos', 'smartos', '5.11', '2.4')
          ).to eq('apache')
      end
    end
  end

  # omnios-151006
  context 'for omnios-151006' do
    context 'when looking up default version' do
      it 'returns the correct version' do
        expect(
          default_version_for('omnios', 'omnios', '151006')
          ).to eq('2.2')
      end
    end

    context 'when looking up package' do
      it 'returns the correct package for httpd 2.2' do
        expect(
          package_name_for('omnios', 'omnios', '151006', '2.2')
          ).to eq('apache22')
      end

      it 'returns the correct package for httpd 2.4' do
        expect(
          package_name_for('omnios', 'omnios', '151006', '2.4')
          ).to eq(nil)
      end
    end
  end
end
