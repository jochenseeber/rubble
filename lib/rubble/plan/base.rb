require 'rubble/dsl'
require 'docile'

module Rubble
    module Plan
        class Base
            attr_reader :env
            attr_reader :target
            attr_reader :resource
            attr_reader :server
            def initialize(env, server, params)
                @env = env
                @server = server
                params.each do |k, v|
                    @resource = k
                    @target = v
                end
            end
        end
    end
end
