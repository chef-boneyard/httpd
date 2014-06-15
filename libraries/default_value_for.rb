module Opscode
  module Httpd
    module Helpers
      ## MPM section
      def default_value_for(version, mpm, parameter)
        MPMinfo.mpm_info[version][mpm][parameter]
      rescue NoMethodError
        nil
      end

      # http://httpd.apache.org/docs/2.2/mod/mpm_common.html
      # http://httpd.apache.org/docs/2.4/mod/mpm_common.html
      class MPMinfo
        def self.mpm_info
          @mpm_info ||= {
            '2.2' => {
              :prefork => {
                :startservers => '5',
                :minspareservers => '5',
                :maxspareservers => '10',
                :maxclients => '150',
                :maxrequestsperchild => '0',
                :minsparethreads => nil,
                :maxsparethreads => nil,
                :threadlimit => nil,
                :threadsperchild => nil,
                :maxrequestworkers => nil,
                :maxconnectionsperchild => nil
              },
              :worker => {
                :startservers => '2',
                :minspareservers => nil,
                :maxspareservers => nil,
                :maxclients => '150',
                :maxrequestsperchild => '0',
                :minsparethreads => '25',
                :maxsparethreads => '75',
                :threadlimit => '64',
                :threadsperchild => '25',
                :maxrequestworkers => nil,
                :maxconnectionsperchild => nil
              },
              :event => {
                :startservers => '2',
                :minspareservers => nil,
                :maxspareservers => nil,
                :maxclients => '150',
                :maxrequestsperchild => '0',
                :minsparethreads => '25',
                :maxsparethreads => '75',
                :threadlimit => '64',
                :threadsperchild => '25',
                :maxrequestworkers => nil,
                :maxconnectionsperchild => nil
              }
            },
            '2.4' => {
              :prefork => {
                :startservers => '5',
                :minspareservers => '5',
                :maxspareservers => '10',
                :maxclients => nil,
                :maxrequestsperchild => nil,
                :minsparethreads => nil,
                :maxsparethreads => nil,
                :threadlimit => nil,
                :threadsperchild => nil,
                :maxrequestworkers => '150',
                :maxconnectionsperchild => '0'
              },
              :worker => {
                :startservers => '2',
                :minspareservers => nil,
                :maxspareservers => nil,
                :maxclients => nil,
                :maxrequestsperchild => nil,
                :minsparethreads => '25',
                :maxsparethreads => '75',
                :threadlimit => '64',
                :threadsperchild => '25',
                :maxrequestworkers => '150',
                :maxconnectionsperchild => '0'
              },
              :event => {
                :startservers => '2',
                :minspareservers => nil,
                :maxspareservers => nil,
                :maxclients => nil,
                :maxrequestsperchild => nil,
                :minsparethreads => '25',
                :maxsparethreads => '75',
                :threadlimit => '64',
                :threadsperchild => '25',
                :maxrequestworkers => '150',
                :maxconnectionsperchild => '0'
              }
            }
          }
        end
      end
    end
  end
end
