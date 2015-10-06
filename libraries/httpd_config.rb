module HttpdCookbook
  class HttpdConfig < ChefCompat::Resource
    property :config_name, String, name_property: true, required: true
    property :cookbook, String, default: nil
    property :httpd_version, String, default: lazy { default_apache_version }
    property :instance, String, default: 'default'
    property :source, String, default: nil
    property :variables, [Hash], default: nil

    include HttpdCookbook::Helpers
  end
end
