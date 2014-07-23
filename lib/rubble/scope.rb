module Rubble
    class Scope
        attr_reader :environment
        attr_reader :server
        def initialize(environment, server)
            @environment = environment
            @server = server
        end

        def tool
            @environment.tool
        end

        def configure_plan(type, *params, &block)
            plan = tool.create_plan(type, @environment, @server, *params)

            if not block.nil? then
                Docile.dsl_eval(plan, &block)
            end

            @environment.add_plan(plan)
        end

        def method_missing(symbol, *arguments, &block)
            if tool.is_plan?(symbol) then
                configure_plan(symbol, *arguments, &block)
            elsif tool.is_target?(symbol) then
                @server.provide_target(symbol, arguments[0])
            elsif tool.is_resource?(symbol) then
                tool.provide_resource(symbol, arguments[0])
            else
                super
            end
        end

        def respond_to?(symbol, include_private = false)
            if tool.is_plan?(symbol) or tool.is_resource?(symbol) or tool.is_target?(symbol) then
                true
            else
                super
            end
        end
    end
end
