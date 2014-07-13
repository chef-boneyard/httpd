module Httpd
  module Service
    module Helpers
      ## MPM section
      def default_mpm_for(version)
        MPMinfo.mpm_version_map[version]
      rescue NoMethodError
        nil
      end

      class MPMinfo
        def self.mpm_version_map
          @version_map ||= {
            '2.2' => 'worker',
            '2.4' => 'event'
          }
        end
      end
    end
  end
end
