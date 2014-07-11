module Opscode
  module Httpd
    module Module
      module Helpers

        module ModuleInfoDSL
          #
          # Given a key, which is a hash of criteria (i.e. module name, platform,
          # version, httpd_version), this method will return for you the package
          # where that module exists. `Nil` is returned if the key does not match
          # any of the defined criteria.
          #
          # @example Searching for the 'alias' module on debian 10.04 with
          #   httpd version 2.2
          #
          #     ModuleInfo.find(:module => 'alias', :platform_family => 'debian', :version => '10.04', :httpd_version: '2.2')
          #
          def find(key)
            found_key = modules_list.keys.find { |lock| key.merge(lock) == key }
            modules_list[found_key]
          end

          #
          # Define what package stores a list of modules based on the any of the
          # criteria: module platform_family, platform, version, httpd_version.
          #
          # @example Module 'ssl' on an Amazon 2014.03 instance using httpd version 2.4 can be found in the package 'mod_ssl'
          #
          #    modules for: { platform: "amazon", version: "2014.03", httpd_version: "2.4" },
          #      are: [ "ssl" ], found_in_package: -> (name) { "mod_#{name}" }
          #
          # When defining the criteria you can specify as little or as much
          # criteria you need. Not specifying the field means that field allows
          # any value.
          #
          # @example Module 'alias' on an Debian instance using httpd version 2.2 can be found in the package 'apache2'
          #
          #    modules for: { platform_family: "debian", httpd_version: "2.2" },
          #      are: [ "alias" ], found_in_package: -> (name) { "apache2" }
          #
          #
          # This states that the 'alias' module is found on any version
          # (e.g. 7, 10.04, 12.04) of Debian with httpd version 2.2.
          #
          def modules(options)
            options[:are].each do |mod|
              key = options[:for].merge(:module => mod)

              package = options[:found_in_package]
              package = package.call(mod) if package.is_a?(Proc)

              modules_list[key] = package
            end
          end

          def modules_list
            @modules_list ||= {}
          end
        end

      end
    end
  end
end