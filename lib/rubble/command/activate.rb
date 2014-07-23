require 'rubble/plan/base'

module Rubble
    module Plan
        class Activate < Base
            def execute
                current_war = File.join(deploy_dir, 'current', target.war)
                remote.cd(target.webapps_dir)
                remote.symlink(current_war, File.basename(current_war))
            end
        end
    end
end
