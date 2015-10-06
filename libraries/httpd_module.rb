module HttpdCookbook
  class HttpdModule < ChefCompat::Resource
    property :filename, kind_of: String
    property :httpd_version, kind_of: String
    property :instance, kind_of: String, default: 'default'
    property :module_name, kind_of: String, name_property: true, required: true
    property :package_name, kind_of: String
    property :symbolname, kind_of: String

    declare_action_class.class_eval { include HttpdCookbook::Helpers }
  end
end
