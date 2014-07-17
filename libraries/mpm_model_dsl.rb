module Httpd
  module Service
    module Helpers
      module MPMModelDSL
        #
        # Given key, which is a hash of criteria, (i.e. httpd_version), this
        # method will return for you the mpm model value. `Nil` is returned if
        # no mpm model matches the criteria.
        #
        # @example Searching for the mpm model to use for httpd version 2.4
        #
        #     MPMModelInfo.find(:httpd_version => '2.4')
        #
        def find(key)
          found_key = mpm_models_list.keys.find { |lock| key.merge(lock) == key }
          mpm_models_list[found_key]
        end

        #
        # Define the mpm model to use for a specified criteria.
        #
        # @example use the 'worker' mpm model when the httpd version is '2.2'
        #
        #     use :model => 'worker', :for => { :httpd_version => '2.2' }
        #
        #
        def use(options)
          model_name = options[:model]
          key = options[:for]

          mpm_models_list[key] = model_name
        end

        def mpm_models_list
          @mpm_models_list ||= {}
        end
      end
    end
  end
end
