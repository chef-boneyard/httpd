module HttpdCookbook
  class HttpdModule < Chef::Resource
    #####################
    # Resource properties
    #####################
    property :filename, String, default: lazy { default_filename }
    property :httpd_version, String, default: lazy { default_apache_version }
    property :instance, String, default: 'default'
    property :module_name, String, name_property: true, required: true
    property :package_name, String, default: lazy { default_package_name }
    property :symbolname, default: lazy { default_symbolname }
    include HttpdCookbook::Helpers

    ################
    # Helper Methods
    ################
    def default_filename
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
    end

    def default_package_name
      package_name_for_module(
        module_name,
        httpd_version,
        node['platform'],
        node['platform_family'],
        node['platform_version']
      )
    end

    def default_symbolname
      return 'php5_module' if module_name == 'php'
      return 'php5_module' if module_name == 'php-zts'
      "#{module_name}_module"
    end
  end
end
