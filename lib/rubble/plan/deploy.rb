require 'rubble/plan/base'

module Rubble
    module Plan
        class Deploy < Base
            def execute(context)
                @target.deploy(context, env, server, @resource)
            end
        end
    end
end
