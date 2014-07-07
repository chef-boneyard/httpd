module Opscode
  module Httpd
    module Module
      module Helpers
        def package_name_for_module(_name, _httpd_version, _platform, _platform_version)
          'apache2'
        end
      end
    end
  end
end
