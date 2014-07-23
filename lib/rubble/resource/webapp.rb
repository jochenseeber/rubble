require 'rubble/resource/base'
require 'rubble/file_set'

module Rubble
    module Resource
        class Webapp < Base
            dsl_accessor :war

            def initialize(name, *params)
                super(name, *params)

                @war = "target/#{name}.war"
            end

            def get_filesets
                dir = File.dirname(@war)
                files = [File.basename(@war)]
                [FileSet.new(dir, files)]
            end
        end
    end
end
