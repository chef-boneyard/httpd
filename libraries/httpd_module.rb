module HttpdCookbook
  class HttpdModule < ChefCompat::Resource
    property :filename, String, default: lazy {
      case node['platform_family']
      when 'debian'
        return 'libphp5.so' if module_name == 'php5'
      when 'rhel'
        return 'libmodnss.so' if module_name == 'nss'
        return 'mod_rev.so' if module_name == 'revocator'
        return 'libphp5.so' if module_name == 'php'
        return 'libphp5-zts.so' if module_name == 'php-zts'
      end
      "mod_#{module_name}.so"
    }
    property :httpd_version, String, default: lazy { default_apache_version }
    property :instance, String, default: 'default'
    property :module_name, String, name_property: true, required: true
    property :package_name, String, default: lazy {
      package_name_for_module(
        module_name,
        httpd_version,
        node['platform'],
        node['platform_family'],
        node['platform_version']
      )
    }
    property :symbolname, default: lazy {
      return 'php5_module' if module_name == 'php'
      return 'php5_module' if module_name == 'php-zts'
      "#{module_name}_module"
    }
    include HttpdCookbook::Helpers
  end
end
