module HttpdCookbook
  class HttpdConfig < ChefCompat::Resource
    property :config_name, kind_of: String, name_property: true, required: true
    property :cookbook, kind_of: String, default: nil
    property :httpd_version, kind_of: String, default: nil
    property :instance, kind_of: String, default: 'default'
    property :source, kind_of: String, default: nil
    property :variables, kind_of: [Hash], default: nil

    declare_action_class.class_eval { include HttpdCookbook::Helpers }
  end
end
