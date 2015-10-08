module HttpdCookbook
  class HttpdModule < ChefCompat::Resource
    property :filename, String
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
