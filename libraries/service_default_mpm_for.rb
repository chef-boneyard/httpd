require_relative 'mpm_model_dsl'

module Httpd
  module Service
    module Helpers
      def default_mpm_for(version)
        MPMModelInfo.find :httpd_version => version
      end

      def default_mpm
        default_mpm_for(node['httpd']['version'])
      end
      
      class MPMModelInfo
        extend MPMModelDSL

        use :model => 'worker', :for => { :httpd_version => '2.2' }

        use :model => 'event', :for => { :httpd_version => '2.4' }
      end
    end
  end
end
