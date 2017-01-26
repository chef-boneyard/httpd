# DSL bits
module HttpdCookbook
  module Helpers
    module MPMConfigParameterDSL
      #
      # Define the configuration parameter value for any criteria: mpm_model,
      # httpd_version, etc.
      #
      # @example define parameters for httpd version 2.4 when using the mpm
      #   'event' model.
      #
      #     config :for => { :httpd_version => '2.4', :mpm_model => 'event' },
      #            :are => {
      #              :minspareservers => '5',
      #              :maxspareservers => '10'
      #            }
      # When defining the criteria you can specify as little or as much
      # criteria you need. Not specifying the field means that field allows
      # any value.
      #
      # @example Setting the the maxclients for all versions of httpd that are
      #   using
      #
      # @note the order that these configs are defined are important. The first
      #   one to match will return that value. So that ensure the more specific
      #   settings are defined first and the more general ones defined later.
      #
      def config(options)
        options[:are].each do |parameter, value|
          key = options[:for].merge(parameter: parameter)

          configuration[key] = value
        end
      end

      def configuration
        @configuration ||= {}
      end

      #
      # Given a key, which is a hash of criteria (i.e. httpd_version,
      # mpm_model, parameter), this method will return for you the
      # configuration parameter value. `Nil` is returned if no preset value
      # for the parameter exists
      #
      # @example Searching for the 'maxclients' value for httpd version 2.2
      #   when using the 'prefork' mpm model
      #
      #     MPMConfigInfo.find(:parameter => :maxclients, :httpd_version => '2.2', :mpm_model => 'prefork')
      #
      def find(key)
        # require 'pry' ; binding.pry
        found_key = configuration.keys.find { |lock| key.merge(lock) == key }
        configuration[found_key]
      end
    end
  end
end

# Info bits
module HttpdCookbook
  module Helpers
    class MPMConfigInfo
      extend MPMConfigParameterDSL

      # http://httpd.apache.org/docs/2.2/mod/mpm_common.html
      # http://httpd.apache.org/docs/2.4/mod/mpm_common.html

      config for: { httpd_version: '2.2', mpm_model: 'prefork' },
             are: {
               startservers: '5',
               minspareservers: '5',
               maxspareservers: '10',
               maxclients: '150',
               maxrequestsperchild: '0',
               minsparethreads: nil,
               maxsparethreads: nil,
               threadlimit: nil,
               threadsperchild: nil,
               maxrequestworkers: nil,
               maxconnectionsperchild: nil,
             }

      config for: { httpd_version: '2.2', mpm_model: 'worker' },
             are: {
               startservers: '2',
               minspareservers: nil,
               maxspareservers: nil,
               maxclients: '150',
               maxrequestsperchild: '0',
               minsparethreads: '25',
               maxsparethreads: '75',
               threadlimit: '64',
               threadsperchild: '25',
               maxrequestworkers: nil,
               maxconnectionsperchild: nil,
             }

      config for: { httpd_version: '2.2', mpm_model: 'event' },
             are: {
               startservers: '2',
               minspareservers: nil,
               maxspareservers: nil,
               maxclients: '150',
               maxrequestsperchild: '0',
               minsparethreads: '25',
               maxsparethreads: '75',
               threadlimit: '64',
               threadsperchild: '25',
               maxrequestworkers: nil,
               maxconnectionsperchild: nil,
             }

      config for: { httpd_version: '2.4', mpm_model: 'prefork' },
             are: {
               startservers: '5',
               minspareservers: '5',
               maxspareservers: '10',
               maxclients: nil,
               maxrequestsperchild: nil,
               minsparethreads: nil,
               maxsparethreads: nil,
               threadlimit: nil,
               threadsperchild: nil,
               maxrequestworkers: '150',
               maxconnectionsperchild: '0',
             }

      config for: { httpd_version: '2.4', mpm_model: 'worker' },
             are: {
               startservers: '2',
               minspareservers: nil,
               maxspareservers: nil,
               maxclients: nil,
               maxrequestsperchild: nil,
               minsparethreads: '25',
               maxsparethreads: '75',
               threadlimit: '64',
               threadsperchild: '25',
               maxrequestworkers: '150',
               maxconnectionsperchild: '0',
             }

      config for: { httpd_version: '2.4', mpm_model: 'event' },
             are: {
               startservers: '2',
               minspareservers: nil,
               maxspareservers: nil,
               maxclients: nil,
               maxrequestsperchild: nil,
               minsparethreads: '25',
               maxsparethreads: '75',
               threadlimit: '64',
               threadsperchild: '25',
               maxrequestworkers: '150',
               maxconnectionsperchild: '0',
             }
    end

    def default_value_for(version, mpm, parameter)
      MPMConfigInfo.find httpd_version: version, mpm_model: mpm, parameter: parameter
    end
  end
end
