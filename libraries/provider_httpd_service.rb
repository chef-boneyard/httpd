require_relative 'helpers'

class Chef
  class Provider
    class HttpdService < Chef::Provider::LWRPBase
      include HttpdCookbook::Helpers

      def action_create
      end

      def action_delete
      end

      def action_restart
      end

      def action_reload
      end
    end
  end
end
