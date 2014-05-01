require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class CrossplatThing < Chef::Resource::LWRPBase
      self.resource_name = :crossplat_thing
      actions  :create
      default_action :create
    end
  end
end
