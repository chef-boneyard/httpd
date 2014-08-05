module Httpd
  module Module
    module Helpers
      module ModuleDetailsDSL
        def module_details(options)
          options[:are].each do |mod|
            # key = options[:for]
            key = options[:for].merge(:module => mod)
            require 'pry'; binding.pry
          end
        end

        def module_details_data
          @module_details_data ||= {}
        end
      end
    end
  end
end
