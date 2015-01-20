class Chef
  class Resource
    class HttpdConfig < Chef::Resource::LWRPBase
      self.resource_name = :httpd_config
      default_action :create
      actions :create, :delete

      attribute :config_name, kind_of: String, name_attribute: true, required: true
      attribute :cookbook, kind_of: String, default: nil
      attribute :httpd_version, kind_of: String, default: nil
      attribute :instance, kind_of: String, default: 'default'
      attribute :source, kind_of: String, default: nil
      attribute :variables, kind_of: [Hash], default: nil
    end
  end
end
