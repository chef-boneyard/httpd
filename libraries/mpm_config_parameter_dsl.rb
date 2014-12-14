module Httpd
  module Service
    module Helpers
      module MPMConfigParameterDSL
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
          found_key = configuration.keys.find { |lock| key.merge(lock) == key }
          configuration[found_key]
        end

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
      end
    end
  end
end
