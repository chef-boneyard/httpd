class Chef
  class Resource
    class HttpdModule < Chef::Resource::LWRPBase
      self.resource_name = :httpd_module
      actions :create, :delete
      default_action :create

      attribute :filename, kind_of: String
      attribute :httpd_version, kind_of: String
      attribute :instance, kind_of: String, default: 'default'
      attribute :module_name, kind_of: String, name_attribute: true, required: true
      attribute :package_name, kind_of: String
      attribute :symbolname, kind_of: String
    end
  end
end
