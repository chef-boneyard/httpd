require_relative 'helpers'

class Chef
  class Provider
    class HttpdModule < Chef::Provider::LWRPBase
      include HttpdCookbook::Helpers

      def action_create
      end

      def action_delete
      end
    end
  end
end
