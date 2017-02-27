module HttpdCookbook
  class HttpdConfig < Chef::Resource
    property :config_name, String, name_property: true, required: true
    property :cookbook, [String, nil], default: nil
    property :httpd_version, String, default: lazy { default_apache_version }
    property :instance, String, default: 'default'
    property :source, [String, nil], default: nil
    property :variables, [Hash], default: {}

    include HttpdCookbook::Helpers
  end
end
