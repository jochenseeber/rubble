require 'rubble/scope'
require 'docile'

module Rubble
    class Environment
        attr_reader :tool
        attr_reader :name
        attr_reader :plans

        # Action statt plan

        def initialize(tool, name)
            @tool = tool
            @name = name
            @plans = []
        end

        def server(*names, &block)
            names.each do |name|
                server = @tool.provide_server(name)
                scope = Scope.new(self, server)
                if not block.nil? then
                    Docile.dsl_eval(scope, &block)
                end
            end
        end

        def add_plan(plan)
            @plans << plan
        end

        def execute(context)
            @plans.each do |plan|
                yield(plan, context)
            end
        end
    end
end
