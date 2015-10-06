module HttpdCookbook
  class HttpdModule < ChefCompat::Resource
    property :filename, String
    property :httpd_version, String, default: lazy { default_apache_version }
    property :instance, String, default: 'default'
    property :module_name, String, name_property: true, required: true
    property :package_name, String
    property :symbolname, String

    include HttpdCookbook::Helpers
  end
end
