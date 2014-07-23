require 'rubble/target/base'

module Rubble
    module Target
        class Tomcat < Base
            dsl_accessor :base_dir
            dsl_accessor :webapps_dir

            def initialize(name)
                super(name)
                @base_dir = "/var/lib/tomcat7#{suffix}"
                @webapps_dir = "webapps"
            end

            def webapps_dir
                File.expand_path(@base_dir, @webapps_dir)
            end
        end
    end
end
