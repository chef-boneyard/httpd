

module Httpd
  module Module
    module Helpers
      module ModuleDetailsDSL
        
        def after_installing(options)
#          require 'pry'; binding.pry
          
          # options[:packages_for].each do |mod|
          #   require 'pry'; binding.pry
          # end
          
        end

        def module_details_data
          @module_details_data ||= {}
        end
      end
    end
  end
end
