module Httpd
  module Module
    module Helpers
      module ModuleInfoDSL

        def find(key)
          found_key = modules_list.keys.find { |lock| key.merge(lock) == key }
          modules_list[found_key]
        end

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
