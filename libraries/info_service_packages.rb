# DSL bits
module HttpdCookbook
  module Helpers
    module ServicePackageDSL
      def pkgname(options)
        configuration[options[:for]] = options[:is]
      end

      def configuration
        @configuration ||= {}
      end

      def find(key)
        # require 'pry' ; binding.pry
        found_key = configuration.keys.find { |lock| key.merge(lock) == key }
        configuration[found_key]
      end
    end
  end
end

# Info bits
module HttpdCookbook
  module Helpers
    class ServicePackageInfo
      extend ServicePackageDSL

      pkgname for: { platform: 'amazon', httpd_version: '2.2' }, is: 'httpd'
      pkgname for: { platform: 'amazon', httpd_version: '2.4' }, is: 'httpd24'
      pkgname for: { platform: 'fedora', httpd_version: '2.4' }, is: 'httpd'
      pkgname for: { platform: 'omnios', httpd_version: '2.2' }, is: 'apache22'
      pkgname for: { platform: 'omnios', httpd_version: '2.4' }, is: 'apache24'
      pkgname for: { platform: 'smartos', httpd_version: '2.0' }, is: 'apache'
      pkgname for: { platform: 'smartos', httpd_version: '2.2' }, is: 'apache'
      pkgname for: { platform: 'smartos', httpd_version: '2.4' }, is: 'apache'
      pkgname for: { platform_family: 'debian', httpd_version: '2.2' }, is: 'apache2'
      pkgname for: { platform_family: 'debian', httpd_version: '2.4' }, is: 'apache2'
      pkgname for: { platform_family: 'rhel', httpd_version: '2.2' }, is: 'httpd'
      pkgname for: { platform_family: 'rhel', httpd_version: '2.4' }, is: 'httpd'
      pkgname for: { platform_family: 'suse', httpd_version: '2.4' }, is: 'apache2'
      pkgname for: { platform_family: 'freebsd', httpd_version: '2.4' }, is: 'apache24'

      # require 'pry' ; binding.pry
    end

    def package_name_for_service(platform, platform_family, platform_version, httpd_version)
      ServicePackageInfo.find(
        platform: platform,
        platform_family: platform_family,
        platform_version: platform_version,
        httpd_version: httpd_version
      )
    end
  end
end
