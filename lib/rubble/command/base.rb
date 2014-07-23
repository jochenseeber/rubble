require 'rubble/dsl'

module Rubble
    module Command
        class Base
            attr_reader :plan
            attr_reader :context
            attr_reader :local
            attr_reader :remote

            def initialize(plan, context)
                @log = Logging.logger[self]
                @plan = plan
                @context = context
            end

            def server
                @plan.server
            end

            def target
                @plan.target
            end

            def resource
                @plan.resource
            end

            def env
                @plan.env
            end

            def local
                if @local.nil? then
                    @local = context.local_executor
                end
                @local
            end

            def remote
                if @remote.nil? then
                    @remote = context.remote_executor(server)
                end
                @remote
            end

            def resolve(string)
                string = '"' << string.gsub('"', '\"') << '"'
                eval(string, binding)
            end

            def deploy_dir
                resolve(File.join(server.rubble_dir, server.deploy_dir))
            end
        end
    end
end
